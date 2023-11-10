pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WOL is ERC20 {
    constructor() ERC20("World Of Legends", "WOL") {
        _mint(msg.sender, 100000000 * (10 ** uint256(decimals())));
    }
}