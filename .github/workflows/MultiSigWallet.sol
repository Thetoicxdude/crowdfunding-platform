// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    address[] public owners;
    uint public required;

    struct Transaction {
        address to;
        uint value;
        bool executed;
    }

    mapping(uint => Transaction) public transactions;
    uint public transactionCount;

    constructor(address[] memory _owners, uint _required) {
        owners = _owners;
        required = _required;
    }

    function submitTransaction(address _to, uint _value) external {
        transactionCount++;
        transactions[transactionCount] = Transaction({
            to: _to,
            value: _value,
            executed: false
        });
    }

    function confirmTransaction(uint _transactionId) external {
        Transaction storage txn = transactions[_transactionId];
        require(!txn.executed, "Transaction already executed");

        // 验证签名
        if (/* 满足签名数量 */) {
            txn.executed = true;
            payable(txn.to).transfer(txn.value);
        }
    }
}
