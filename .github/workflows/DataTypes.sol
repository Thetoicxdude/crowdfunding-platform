// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library DataTypes {
    struct Project {
        address owner;
        uint256 goal;
        uint256 raised;
        uint256 deadline;
        bool completed;
    }
}
