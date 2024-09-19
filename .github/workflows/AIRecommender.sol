// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AIRecommender {
    mapping(address => uint[]) public userRecommendations;

    function setRecommendations(address _user, uint[] memory _recommendations) external {
        userRecommendations[_user] = _recommendations;
    }

    function getRecommendations(address _user) external view returns (uint[] memory) {
        return userRecommendations[_user];
    }
}
