//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract DEX {
  
  using SafeMath for uint;

  IERC20 internal token;

  constructor() {
    token = IERC20(0x755529CAbA040EA7110143c7CD1d3Df599Da012a);
  }

  event Bought(uint256 amount);
  event Sold(uint256 amount);

  function buy() payable external {
    uint256 dexBalance = token.balanceOf(address(this));
    uint const = (address(this).balance.sub(msg.value)).mul(dexBalance);
    uint finalSupply = const.div(address(this).balance);
    uint amount = dexBalance.sub(finalSupply);
    require(msg.value > 0, "You need to send some ether");
    require(amount <= dexBalance, "Not enough tokens in the reserve");
    token.transfer(msg.sender, amount);
    emit Bought(amount);
  }    

  function sell(uint256 amount) external { 
    uint const = address(this).balance.mul(token.balanceOf(address(this)));
    uint finalSupply = token.balanceOf(address(this)).add(amount);
    uint amountTosend = address(this).balance.sub(const.div(finalSupply));
    require(amount > 0, "You need to sell at least some tokens");
    token.transferFrom(msg.sender, address(this), amount);
    payable(msg.sender).transfer(amountTosend); 
    emit Sold(amount);
  }

  fallback() external payable { }

}
