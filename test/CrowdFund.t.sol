// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {CrowdFund} from "../src/CrowdFund.sol";
import {Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {DeployCrowdFund} from "../script/DeployCrowdFund.s.sol";

contract TestCrowdFund is Test {
    CrowdFund public crowdFund;
    address public constant TEST_FUNDER = address(1);
    address public constant TEST_OWNER = address(2);
    

    function setUp() public {
       DeployCrowdFund deployer = new DeployCrowdFund();
       deployer.run(); 
    }

    function testMinimumUsdRequirement() public {
        vm.prank(TEST_FUNDER);
        vm.expectRevert("Require91UsdOrMore()");
        // Sending 0.01 ETH which is less than $90
        crowdFund.sendFunds{value: 1e10}(); 
    }


}