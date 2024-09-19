// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Membership {
    mapping(address => uint256) public userLevels;

    event UserRegistered(address indexed user, uint256 level);
    
    function registerUser(address _user, uint256 _level) external {
        require(_level > 0, "Invalid level");
        userLevels[_user] = _level;
        emit UserRegistered(_user, _level);
    }

    function getUserLevel(address _user) external view returns (uint256) {
        return userLevels[_user];
    }
}
