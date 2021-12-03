// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @custom:security-contact security@battlecity.io
contract WorldOfLegends is ERC20 {
    constructor() ERC20("World Of Legends", "WOL") {
        _mint(msg.sender, 100000000 * 10 ** decimals());
    }
}
