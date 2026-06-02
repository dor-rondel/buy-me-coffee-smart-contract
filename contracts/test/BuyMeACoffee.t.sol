// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/BuyMeACoffee.sol";
import "../script/BuyMeACoffee.s.sol";

contract BuyMeACoffeeTest is Test {
    BuyMeACoffee public buyMeACoffee;
    address public USER = makeAddr("user");
    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 public constant STARTING_BALANCE = 10 ether;

    function setUp() public {
        BuyMeACoffeeScript deployer = new BuyMeACoffeeScript();
        buyMeACoffee = deployer.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function test_barebone() public view {
        // Empty test to ensure forge test finds at least one test
        assertEq(address(buyMeACoffee) != address(0), true);
    }

    function test_ReceiveCallsFund() public {
        vm.prank(USER);
        (bool success,) = address(buyMeACoffee).call{value: SEND_VALUE}("");
        assertTrue(success);
        assertEq(address(buyMeACoffee).balance, SEND_VALUE);
        assertEq(buyMeACoffee.getNumberOfDonors(), 1);
    }

    function test_FallbackCallsFund() public {
        vm.prank(USER);
        // Sending with some data to trigger fallback
        (bool success,) =
            address(buyMeACoffee).call{value: SEND_VALUE}(abi.encodeWithSignature("nonExistentFunction()"));
        assertTrue(success);
        assertEq(address(buyMeACoffee).balance, SEND_VALUE);
        assertEq(buyMeACoffee.getNumberOfDonors(), 1);
    }

    function test_ReceiveRevertsIfNotEnoughETH() public {
        uint256 amount = 0.0001 ether; // ~ $0.2, less than $3 minimum
        vm.deal(USER, amount);
        vm.prank(USER);

        (bool success,) = address(buyMeACoffee).call{value: amount}("");
        assertFalse(success);
    }

    function test_FallbackRevertsIfNotEnoughETH() public {
        uint256 amount = 0.0001 ether; // ~ $0.2, less than $3 minimum
        vm.deal(USER, amount);
        vm.prank(USER);

        (bool success,) = address(buyMeACoffee).call{value: amount}(abi.encodeWithSignature("nonExistentFunction()"));
        assertFalse(success);
    }

    function test_FundRecordsDonor() public {
        string memory message = "Hello, world!";
        vm.prank(USER);
        buyMeACoffee.fund{value: SEND_VALUE}(message);

        BuyMeACoffee.Donor memory donor = buyMeACoffee.getDonor(0);
        assertEq(donor.donor, USER);
        assertEq(donor.message, message);
        assertEq(donor.amount, SEND_VALUE);
        assertEq(donor.timestamp, block.timestamp);
    }

    function test_FundRevertsIfMessageTooLong() public {
        string memory longMessage =
            "This message is definitely longer than two hundred characters. Let's make it even longer to be sure. Still not long enough? Okay, here is some more text to fill up the space and exceed the limit of two hundred characters for sure.";
        vm.prank(USER);
        vm.expectRevert(BuyMeACoffee__MessageTooLong.selector);
        buyMeACoffee.fund{value: SEND_VALUE}(longMessage);
    }

    function test_WithdrawOnlyOwner() public {
        vm.prank(USER);
        buyMeACoffee.fund{value: SEND_VALUE}("");

        vm.prank(USER);
        vm.expectRevert(BuyMeACoffee__NotOwner.selector);
        buyMeACoffee.withdraw();
    }

    function test_WithdrawWithSingleOwner() public {
        // Arrange
        uint256 startingOwnerBalance = buyMeACoffee.getOwner().balance;
        uint256 startingContractBalance = address(buyMeACoffee).balance;

        vm.prank(USER);
        buyMeACoffee.fund{value: SEND_VALUE}("");
        uint256 midContractBalance = address(buyMeACoffee).balance;

        // Act
        vm.prank(buyMeACoffee.getOwner());
        buyMeACoffee.withdraw();

        // Assert
        uint256 endingOwnerBalance = buyMeACoffee.getOwner().balance;
        uint256 endingContractBalance = address(buyMeACoffee).balance;

        assertEq(endingContractBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + midContractBalance);
    }
}
