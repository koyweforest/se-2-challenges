pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {
    // ToDo: add constructor and mint tokens for deployer,
    //       you can use the above import for ERC20.sol. Read the docs ^^^

     constructor() ERC20("Koywe USDC", "USDC") {
        //_mint() 1000 * 10 ** 18 to msg.sender
        _mint(msg.sender, 10000000000 * 10 ** 18);
    }
}
