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

    function test_ReceiveCallsFund() public {
        uint256 amount = 0.1 ether;
        vm.deal(address(this), amount);

        (bool success,) = address(buyMeACoffee).call{value: amount}("");
        assertTrue(success);
        assertEq(address(buyMeACoffee).balance, amount);
    }

    function test_FallbackCallsFund() public {
        uint256 amount = 0.1 ether;
        vm.deal(address(this), amount);

        // Sending with some data to trigger fallback
        (bool success,) = address(buyMeACoffee).call{value: amount}(abi.encodeWithSignature("nonExistentFunction()"));
        assertTrue(success);
        assertEq(address(buyMeACoffee).balance, amount);
    }

    function test_ReceiveRevertsIfNotEnoughETH() public {
        uint256 amount = 0.001 ether; // ~ $2, less than $3 minimum
        vm.deal(address(this), amount);

        (bool success,) = address(buyMeACoffee).call{value: amount}("");
        assertFalse(success);
    }

    function test_FallbackRevertsIfNotEnoughETH() public {
        uint256 amount = 0.001 ether; // ~ $2, less than $3 minimum
        vm.deal(address(this), amount);

        (bool success,) = address(buyMeACoffee).call{value: amount}(abi.encodeWithSignature("nonExistentFunction()"));
        assertFalse(success);
    }
}
