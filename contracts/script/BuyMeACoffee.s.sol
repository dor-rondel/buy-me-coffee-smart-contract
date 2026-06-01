// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/BuyMeACoffee.sol";

contract BuyMeACoffeeScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new BuyMeACoffee(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        vm.stopBroadcast();
    }
}
