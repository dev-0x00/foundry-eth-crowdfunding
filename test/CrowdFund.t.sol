// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {CrowdFund} from "../src/CrowdFund.sol";
import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {DeployCrowdFund} from "../script/DeployCrowdFund.s.sol";

contract TestCrowdFund is Test {
    CrowdFund crowdFund;
    address TEST_FUNDER = makeAddr("funder1");
    address TEST_OWNER = makeAddr("owner1");

    uint256 public constant STARTING_BALANCE = 10 ether;
    uint256 public constant SEND_AMOUNT = 0.01 ether;

    function setUp() public {
        DeployCrowdFund deployer = new DeployCrowdFund();
        crowdFund = deployer.run();
    }

    function testMinimumUsdRequirement() public {
        vm.prank(TEST_FUNDER);
        vm.deal(TEST_FUNDER, STARTING_BALANCE);
        vm.expectRevert("Require91UsdOrMore()");
        // Sending 0.01 ETH which is less than $90
        crowdFund.sendFunds{value: SEND_AMOUNT}();
    }

    function sendRequiredFunds() public {
        vm.prank(TEST_FUNDER);
        vm.deal(TEST_FUNDER, STARTING_BALANCE);
        // Sending 1 ETH which is more than $90
        crowdFund.sendFunds{value: 1 ether}();
        uint256 fundedAmount = crowdFund.s_addressToAmount(TEST_FUNDER);
        assertEq(fundedAmount, 1 ether);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.prank(TEST_FUNDER);
        vm.deal(TEST_FUNDER, STARTING_BALANCE);
        vm.expectRevert("NotOwner()");
        crowdFund.withdrawFunds();
    }

    function testOwnerCanWithdraw() public {
        sendRequiredFunds();
        address ownerAddr = crowdFund.owner();
        vm.prank(ownerAddr);
        uint256 initialOwnerBalance = ownerAddr.balance;
        crowdFund.withdrawFunds();
        uint256 finalOwnerBalance = ownerAddr.balance;
        assert(finalOwnerBalance > initialOwnerBalance);
    }

    function testUsersAreAddedToFundersList() public {
        for(int i = 0; i < 3; i++) {
            address funder = makeAddr(string(abi.encodePacked("funder", vm.toString(i))));
            vm.prank(funder);
            vm.deal(funder, STARTING_BALANCE);
            crowdFund.sendFunds{value: 1 ether}();
        }
        for(int i = 0; i < 3; i++) {
            address funder = makeAddr(string(abi.encodePacked("funder", vm.toString(i))));
            address recordedFunder = crowdFund.s_funders(uint256(i));
            assertEq(funder, recordedFunder);
        }
    }
}
