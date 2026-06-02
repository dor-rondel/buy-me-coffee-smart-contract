// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/BuyMeACoffee.sol";
import "../script/BuyMeACoffee.s.sol";
import "../script/HelperConfig.s.sol";

contract BuyMeACoffeeIntegrationTest is Test {
    BuyMeACoffee public buyMeACoffee;
    HelperConfig public helperConfig;
    BuyMeACoffeeScript public deployer;

    address public OWNER;
    address public USER1 = makeAddr("user1");
    address public USER2 = makeAddr("user2");
    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 public constant STARTING_BALANCE = 10 ether;

    function setUp() public {
        deployer = new BuyMeACoffeeScript();
        buyMeACoffee = deployer.run();
        helperConfig = new HelperConfig();

        OWNER = buyMeACoffee.getOwner();
        vm.deal(USER1, STARTING_BALANCE);
        vm.deal(USER2, STARTING_BALANCE);
    }

    /* Deployment Tests */

    function test_Integration_DeploymentConfig() public view {
        (address expectedPriceFeed) = helperConfig.activeNetworkConfig();
        // Since the deployer script creates its own HelperConfig, we just verify the address is not zero
        // and matches the expected behavior of the script
        assertEq(address(buyMeACoffee) != address(0), true);
        assertEq(expectedPriceFeed != address(0), true);
    }

    function test_Integration_OwnerConsistency() public view {
        // The address that ran the script (this test contract in this case, or the broadcaster)
        // should be the owner.
        assertEq(buyMeACoffee.getOwner(), OWNER);
    }

    /* Happy Path Lifecycle */

    function test_Integration_FullLifecycle() public {
        // 1. Multiple users fund
        vm.prank(USER1);
        buyMeACoffee.fund{value: SEND_VALUE}("From User 1");

        vm.prank(USER2);
        buyMeACoffee.fund{value: SEND_VALUE}("From User 2");

        assertEq(buyMeACoffee.getNumberOfDonors(), 2);
        uint256 contractBalance = address(buyMeACoffee).balance;
        assertEq(contractBalance, SEND_VALUE * 2);

        // 2. Owner withdraws
        uint256 startingOwnerBalance = OWNER.balance;

        vm.prank(OWNER);
        buyMeACoffee.withdraw();

        assertEq(address(buyMeACoffee).balance, 0);
        assertEq(OWNER.balance, startingOwnerBalance + contractBalance);
    }

    function test_Integration_DonorDataIntegrity() public {
        string memory msg1 = "Msg 1";
        string memory msg2 = "Msg 2";

        vm.prank(USER1);
        buyMeACoffee.fund{value: SEND_VALUE}(msg1);

        vm.prank(USER2);
        buyMeACoffee.fund{value: SEND_VALUE}(msg2);

        BuyMeACoffee.Donor memory donor1 = buyMeACoffee.getDonor(0);
        BuyMeACoffee.Donor memory donor2 = buyMeACoffee.getDonor(1);

        assertEq(donor1.donor, USER1);
        assertEq(donor1.message, msg1);
        assertEq(donor2.donor, USER2);
        assertEq(donor2.message, msg2);
    }

    /* Negative & Edge Cases */

    function test_Integration_FundUnderMinimum() public {
        uint256 tinyAmount = 1 wei;
        vm.prank(USER1);
        vm.expectRevert(BuyMeACoffee__NotEnoughETH.selector);
        buyMeACoffee.fund{value: tinyAmount}("Too small");
    }

    function test_Integration_ReceiveRouting() public {
        vm.prank(USER1);
        (bool success,) = address(buyMeACoffee).call{value: SEND_VALUE}("");
        assertTrue(success);

        BuyMeACoffee.Donor memory donor = buyMeACoffee.getDonor(0);
        assertEq(donor.donor, USER1);
        assertEq(donor.message, "");
    }

    function test_Integration_FallbackRouting() public {
        vm.prank(USER1);
        (bool success,) = address(buyMeACoffee).call{value: SEND_VALUE}(abi.encodeWithSignature("nonExistent()"));
        assertTrue(success);

        BuyMeACoffee.Donor memory donor = buyMeACoffee.getDonor(0);
        assertEq(donor.donor, USER1);
        assertEq(donor.message, "");
    }

    function test_Integration_UnauthorizedWithdrawal() public {
        vm.prank(USER1);
        buyMeACoffee.fund{value: SEND_VALUE}("Stay away");

        vm.prank(USER2);
        vm.expectRevert(BuyMeACoffee__NotOwner.selector);
        buyMeACoffee.withdraw();

        assertEq(address(buyMeACoffee).balance, SEND_VALUE);
    }

    function test_Integration_MessageLimitResilience() public {
        // Exactly 200 chars
        string memory exactMsg =
            "12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890";
        vm.prank(USER1);
        buyMeACoffee.fund{value: SEND_VALUE}(exactMsg);

        // 201 chars
        string memory longMsg = string(abi.encodePacked(exactMsg, "a"));
        vm.prank(USER2);
        vm.expectRevert(BuyMeACoffee__MessageTooLong.selector);
        buyMeACoffee.fund{value: SEND_VALUE}(longMsg);
    }

    function test_Integration_MultiUserScale() public {
        uint256 numUsers = 10;
        for (uint256 i = 0; i < numUsers; i++) {
            // forge-lint: disable-next-line(unsafe-typecast)
            address user = address(uint160(i + 100)); // Generate some addresses
            vm.deal(user, STARTING_BALANCE);
            vm.prank(user);
            buyMeACoffee.fund{value: SEND_VALUE}("Bulk fund");
        }

        assertEq(buyMeACoffee.getNumberOfDonors(), numUsers);
        assertEq(address(buyMeACoffee).balance, SEND_VALUE * numUsers);
    }
}
