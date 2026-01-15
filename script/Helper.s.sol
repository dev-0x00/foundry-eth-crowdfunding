// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract HelperSol {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } 
        
        else if (block.chainid == 1) {
            activeNetworkConfig = getMainetEthConfig();
        }
        
        else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        });
        return sepoliaConfig;
    }

    function getMainetEthConfig() public pure returns (NetworkConfig memory){
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetConfig;
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory){
        //Deploy mock contract
        //Return the mock address
        
    }
}