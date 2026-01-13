// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/UserCoin.sol";

contract UserCoinScript is Script {
    function run() external {
        vm.startBroadcast();
        UserCoin coin = new UserCoin();
        vm.stopBroadcast();

        console.log("UserCoin deployed at:", address(coin));
    }
}
