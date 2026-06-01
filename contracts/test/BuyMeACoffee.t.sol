// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/BuyMeACoffee.sol";

contract BuyMeACoffeeTest is Test {
    BuyMeACoffee public buyMeACoffee;

    function setUp() public {
        buyMeACoffee = new BuyMeACoffee(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function test_barebone() public {
        // Empty test to ensure forge test finds at least one test
        assertEq(address(buyMeACoffee) != address(0), true);
    }
}
