// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/UserCoin.sol";

contract UserCoinTest is Test {
    UserCoin public coin;
    address public user = makeAddr("user");

    function setUp() public {
        coin = new UserCoin();
        vm.deal(user, 10 ether);
    }

    function test_BuyWithETH() public {
        uint256 ethAmount = 2.5 ether;

        vm.prank(user);
        coin.buy{value: ethAmount}();

        assertEq(coin.balanceOf(user), ethAmount * coin.RATE());
    }

    function test_ReceiveETH() public {
        uint256 ethAmount = 0.7 ether;

        vm.prank(user);
        (bool success,) = address(coin).call{value: ethAmount}("");
        require(success, "ETH transfer failed");

        assertEq(coin.balanceOf(user), ethAmount * coin.RATE());
    }

    function test_RevertWhen_ZeroETH() public {
        vm.expectRevert("Must send ETH to buy UserCoin");
        coin.buy{value: 0}();
    }
}
