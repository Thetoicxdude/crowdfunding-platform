// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Membership {
    mapping(address => uint) public userLevels;

    function setUserLevel(address _user, uint _level) external {
        userLevels[_user] = _level;
    }

    function getUserLevel(address _user) external view returns (uint) {
        return userLevels[_user];
    }
}
