// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.0;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract SUNcoin is ERC20 {
  
  using SafeMath for uint;

  address public admin;

  constructor() ERC20('Sun','SUN') {
    admin = msg.sender;
  }

  function Approve(uint amount) external {
    approve(exchangePool, amount);
  }

  /* @CrowdSale */

  uint internal crowdsale;

  address internal exchangePool;

  event tokensMined(address by, uint amount);

  function startCrowdsale(address wallet) external {
    require(msg.sender == admin, "only admin");
    require(crowdsale == 0, "Crowdsale completed");
    crowdsale = 1;
    exchangePool = wallet;
  }

  function endCrowdsale() external {
    require(msg.sender == admin, "only admin");
    require(crowdsale == 1, "Crowdsale not yet started");
    crowdsale = 2;
    _mint(exchangePool, totalSupply());
    payable(exchangePool).transfer(address(this).balance);
  }  
  
  function crowdSale() external payable {
    require(crowdsale == 1, "crowdsale inactive");
    uint amount = msg.value.div(10**15);
    _mint(msg.sender, amount.mul(10**18));
    emit tokensMined(msg.sender, amount);
  }
  
}
