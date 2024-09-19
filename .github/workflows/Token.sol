// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PlatformToken is ERC20 {
    constructor() ERC20("PlatformToken", "PTK") {
        _mint(msg.sender, 1000000 * 10 ** 18);  // 初始发行100万个代币
    }
}
