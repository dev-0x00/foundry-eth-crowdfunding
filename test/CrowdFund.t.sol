// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {CrowdFund} from "../src/CrowdFund.sol";
import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {DeployCrowdFund} from "../script/DeployCrowdFund.s.sol";

contract TestCrowdFund is Test {
    CrowdFund crowdFund;
    address  TEST_FUNDER = makeAddr("funder1");
    address  TEST_OWNER = makeAddr("owner1");

    uint256 public constant STARTING_BALANCE = 10 ether;
    uint256 public constant SEND_AMOUNT = 0.01 ether;
    

    function setUp() public {
       DeployCrowdFund deployer = new DeployCrowdFund();
       deployer.run(); 
    }

    function testMinimumUsdRequirement() public {
        vm.prank(TEST_FUNDER);
        vm.deal(TEST_FUNDER, STARTING_BALANCE);
        vm.expectRevert("Require91UsdOrMore()");
        // Sending 0.01 ETH which is less than $90
        crowdFund.sendFunds(); 
    }


}