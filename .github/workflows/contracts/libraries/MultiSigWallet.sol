// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    address[] public owners;
    uint256 public requiredApprovals;

    struct Transaction {
        address to;
        uint256 value;
        bool executed;
        uint256 approvals;
    }

    mapping(uint256 => Transaction) public transactions;
    mapping(uint256 => mapping(address => bool)) public approvals;
    uint256 public transactionCount;

    modifier onlyOwner() {
        require(isOwner(msg.sender), "Not owner");
        _;
    }

    modifier notExecuted(uint256 transactionId) {
        require(!transactions[transactionId].executed, "Already executed");
        _;
    }

    modifier notApproved(uint256 transactionId) {
        require(!approvals[transactionId][msg.sender], "Already approved");
        _;
    }

    constructor(address[] memory _owners, uint256 _requiredApprovals) {
        owners = _owners;
        requiredApprovals = _requiredApprovals;
    }

    function isOwner(address account) public view returns (bool) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == account) {
                return true;
            }
        }
        return false;
    }

    function submitTransaction(address to, uint256 value) external onlyOwner {
        transactionCount++;
        transactions[transactionCount] = Transaction({
            to: to,
            value: value,
            executed: false,
            approvals: 0
        });
    }

    function approveTransaction(uint256 transactionId)
        external
        onlyOwner
        notApproved(transactionId)
        notExecuted(transactionId)
    {
        approvals[transactionId][msg.sender] = true;
        transactions[transactionId].approvals++;

        if (transactions[transactionId].approvals >= requiredApprovals) {
            executeTransaction(transactionId);
        }
    }

    function executeTransaction(uint256 transactionId)
        internal
        notExecuted(transactionId)
    {
        Transaction storage txn = transactions[transactionId];
        require(address(this).balance >= txn.value, "Insufficient balance");
        txn.executed = true;
        payable(txn.to).transfer(txn.value);
    }

    receive() external payable {}
}

