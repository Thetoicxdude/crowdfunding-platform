// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../libraries/SafeMath.sol";
import "../membership/Membership.sol";
import "../oracles/PriceOracle.sol";
import "../core/AITracker.sol";

contract FundingContract {
    using SafeMath for uint256;

    IERC20 public token;
    Membership public membership;
    PriceOracle public priceOracle;
    AITracker public aiTracker;

    struct Project {
        address owner;
        uint256 goal;
        uint256 raised;
        uint256 deadline;
        bool completed;
        uint256 fundingFee; 
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectCreated(address indexed owner, uint256 goal, uint256 deadline, uint256 projectId);
    event Funded(address indexed investor, uint256 amount, uint256 projectId);
    event ProjectCompleted(uint256 indexed projectId, uint256 amountTransferred);

    constructor(
        IERC20 _token,
        Membership _membership,
        PriceOracle _priceOracle,
        AITracker _aiTracker
    ) {
        token = _token;
        membership = _membership;
        priceOracle = _priceOracle;
        aiTracker = _aiTracker;
    }

    function createProject(uint256 _goal, uint256 _deadline) external {
        require(_deadline > block.timestamp, "Invalid deadline");

        uint256 membershipLevel = membership.getUserLevel(msg.sender);
        require(membershipLevel > 0, "Not a member");

        projectCount++;
        projects[projectCount] = Project({
            owner: msg.sender,
            goal: _goal,
            raised: 0,
            deadline: _deadline,
            completed: false,
            fundingFee: priceOracle.getFundingFee()
        });

        emit ProjectCreated(msg.sender, _goal, _deadline, projectCount);
    }

    function fundProject(uint256 _projectId, uint256 _amount) external {
        Project storage project = projects[_projectId];
        require(block.timestamp < project.deadline, "Project ended");
        require(!project.completed, "Project already completed");

        uint256 userLevel = membership.getUserLevel(msg.sender);
        require(userLevel > 0, "Not a member");

        token.transferFrom(msg.sender, address(this), _amount);
        project.raised = project.raised.add(_amount);

        aiTracker.logInvestment(msg.sender, _projectId, _amount);

        emit Funded(msg.sender, _amount, _projectId);

        if (project.raised >= project.goal) {
            project.completed = true;
            uint256 fee = project.raised.mul(project.fundingFee).div(100);
            token.transfer(project.owner, project.raised.sub(fee));

            emit ProjectCompleted(_projectId, project.raised.sub(fee));
        }
    }
}
