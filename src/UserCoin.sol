// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract UserCoin is ERC20, Ownable {
    uint256 public constant RATE = 1 ether; // 1 ETH = 1 UserCoin

    constructor() ERC20("UserCoin", "UC") Ownable(msg.sender) {
        // 在此预先铸造一些代币给合约部署者
        _mint(msg.sender, 100_000 * 10 ** decimals());
    }

    /// @notice 接收 ETH 并铸造等值的 UserCoin 给发送者
    receive() external payable {
        require(msg.value > 0, "Must send ETH to mint UserCoin");
        uint256 tokensToMint = msg.value *  RATE;
        _mint(msg.sender, tokensToMint);
    }

    /// @notice 通过发送 ETH 来购买 UserCoin. 同 receive, 但是更显式的函数接口
    function buy() external payable {
        require(msg.value > 0, "Must send ETH to buy UserCoin");
        uint256 tokensToMint = msg.value * RATE;
        _mint(msg.sender, tokensToMint);
    }

    /// @notice owner 将合约中的 ETH 提取到自己名下
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");
        (bool success, ) = payable(msg.sender).call{value: balance}("");
        require(success, "Withdraw failed");
    }
}
