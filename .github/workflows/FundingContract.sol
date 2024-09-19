// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AIRecommender.sol";
import "./Membership.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FundingContract {
    IERC20 public token;
    AIRecommender public aiRecommender;
    Membership public membership;

    struct Project {
        address owner;
        uint goal;
        uint raised;
        uint deadline;
        bool completed;
    }

    mapping(uint => Project) public projects;
    uint public projectCount;

    event ProjectCreated(address indexed owner, uint goal, uint deadline, uint projectId);
    event Funded(address indexed investor, uint amount, uint projectId);

    constructor(IERC20 _token, AIRecommender _aiRecommender, Membership _membership) {
        token = _token;
        aiRecommender = _aiRecommender;
        membership = _membership;
    }

    function createProject(uint _goal, uint _deadline) external {
        require(_deadline > block.timestamp, "Invalid deadline");

        projectCount++;
        projects[projectCount] = Project(msg.sender, _goal, 0, _deadline, false);

        emit ProjectCreated(msg.sender, _goal, _deadline, projectCount);
    }

    function fundProject(uint _projectId, uint _amount) external {
        Project storage project = projects[_projectId];
        require(block.timestamp < project.deadline, "Project ended");
        require(!project.completed, "Project already completed");

        uint userLevel = membership.getUserLevel(msg.sender);
        require(userLevel > 0, "Not a member");

        token.transferFrom(msg.sender, address(this), _amount);
        project.raised += _amount;

        emit Funded(msg.sender, _amount, _projectId);

        if (project.raised >= project.goal) {
            project.completed = true;
            token.transfer(project.owner, project.raised);
        }
    }

    function getRecommendedProjects(address user) external view returns (uint[] memory) {
        return aiRecommender.getRecommendations(user);
    }
}
