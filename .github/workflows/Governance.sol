// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/Roles.sol";

contract Governance {
    using Roles for Roles.Role;

    Roles.Role private admins;
    Roles.Role private voters;

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    struct Proposal {
        string description;
        uint256 voteCount;
        bool executed;
    }

    event ProposalCreated(uint256 indexed proposalId, string description);
    event Voted(address indexed voter, uint256 proposalId);

    constructor() {
        admins.add(msg.sender);
    }

    modifier onlyAdmin() {
        require(admins.has(msg.sender), "Not an admin");
        _;
    }

    modifier onlyVoter() {
        require(voters.has(msg.sender), "Not a voter");
        _;
    }

    function addVoter(address _voter) external onlyAdmin {
        voters.add(_voter);
    }

    function createProposal(string memory _description) external onlyVoter {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            description: _description,
            voteCount: 0,
            executed: false
        });

        emit ProposalCreated(proposalCount, _description);
    }

    function vote(uint256 _proposalId) external onlyVoter {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");

        proposal.voteCount++;
        emit Voted(msg.sender, _proposalId);
    }

    function executeProposal(uint256 _proposalId) external onlyAdmin {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Already executed");
        require(proposal.voteCount > 0, "No votes");

        proposal.executed = true;
        // Execute the proposal logic here
    }
}
