pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable{

  YourToken yourToken;
  uint256 public constant tokensPerEth = 1000;
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  function buyTokens() public payable {
    require(msg.value > 0, "Can't buy 0 tokens.");
    require(yourToken.balanceOf(address(this)) >= tokensPerEth * msg.value, "Vendor doesn't have enough tokens to sell.");
    yourToken.transfer(msg.sender, tokensPerEth * msg.value);
    emit BuyTokens(msg.sender, msg.value, tokensPerEth * msg.value);
  }

  function withdraw() public onlyOwner {
    (bool success, ) = msg.sender.call{value: address(this).balance}("");
    require(success, "Failed to send Native Token");
  }

  function withdrawTokens() public onlyOwner {
    require(yourToken.balanceOf(address(this)) >= 0, "Vendor doesn't have enough tokens to withdraw.");
    yourToken.transfer(msg.sender, yourToken.balanceOf(address(this)));
  }
  
  // ToDo: create a sellTokens() function:
  function sellTokens(uint256 amount) public {
    require(amount > 0, "Can't sell 0 tokens.");
    require(yourToken.balanceOf(address(msg.sender)) >= amount, "You don't have enough tokens to sell.");
    require(address(this).balance >= amount / tokensPerEth, "Vendor ran out of Native Token to buy tokens.");
    (bool success, ) = msg.sender.call{value: amount / tokensPerEth}("");
    require(success, "Failed to send Native Token");
    yourToken.transferFrom(msg.sender, address(this), amount);
    emit SellTokens(msg.sender, amount / tokensPerEth, amount);
  }
}
