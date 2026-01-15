// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256){
        (,int256 price,,,) = priceFeed.latestRoundData();
        // casting to 'uint256' is safe because price feeds return non-negative values
        // forge-lint: disable-next-line(unsafe-typecast)
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmt, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmtInUsd = (ethPrice * ethAmt) / 1e18;
        return ethAmtInUsd;
    }

}
