// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
@title Carina ERC20 Token
@author Vela
*/
contract CarinaToken is ERC20 {
    constructor() ERC20("Carina", "CAR") {
        _mint(msg.sender, 1000000000000000000000000);
    }
}