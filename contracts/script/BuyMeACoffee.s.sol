// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/BuyMeACoffee.sol";
import "./HelperConfig.s.sol";

contract BuyMeACoffeeScript is Script {
    function setUp() public {}

    function run() public returns (BuyMeACoffee) {
        HelperConfig helperConfig = new HelperConfig();
        (address priceFeed) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        BuyMeACoffee buyMeACoffee = new BuyMeACoffee(priceFeed);
        vm.stopBroadcast();
        return buyMeACoffee;
    }
}
