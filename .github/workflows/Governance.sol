// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Governance {
    struct Proposal {
        string description;
        uint votesFor;
        uint votesAgainst;
        bool executed;
    }

    mapping(uint => Proposal) public proposals;
    uint public proposalCount;

    function createProposal(string memory _description) external {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            description: _description,
            votesFor: 0,
            votesAgainst: 0,
            executed: false
        });
    }

    function vote(uint _proposalId, bool _support) external {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");

        if (_support) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }
    }

    function executeProposal(uint _proposalId) external {
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.votesFor > proposal.votesAgainst, "Proposal rejected");

        proposal.executed = true;
        // 执行提案，如修改AI模型或参数
    }
}
