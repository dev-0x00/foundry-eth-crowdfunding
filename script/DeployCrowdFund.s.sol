// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {CrowdFund} from "../src/CrowdFund.sol";
import {Script} from "forge-std/Script.sol";
import {HelperSol} from "./Helper.s.sol";

contract DeployCrowdFund is Script {
    function run() public returns (CrowdFund) {
        HelperSol helper = new HelperSol();
        address ethUsdPriceFeed = helper.activeNetworkConfig();
        vm.startBroadcast();
        CrowdFund crowdFund = new CrowdFund(ethUsdPriceFeed);
        vm.stopBroadcast();
        return crowdFund;
    }
}
