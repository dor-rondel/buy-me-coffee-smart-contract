// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/BuyMeACoffee.sol";
import "../script/BuyMeACoffee.s.sol";

contract BuyMeACoffeeTest is Test {
    BuyMeACoffee public buyMeACoffee;

    function setUp() public {
        BuyMeACoffeeScript deployer = new BuyMeACoffeeScript();
        buyMeACoffee = deployer.run();
    }

    function test_barebone() public {
        // Empty test to ensure forge test finds at least one test
        assertEq(address(buyMeACoffee) != address(0), true);
    }
}
