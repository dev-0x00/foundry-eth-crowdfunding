// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error Require91UsdOrMore();
error NotOwner();
error WithdrwalFailed();

contract CrowdFund {
    using PriceConverter for uint256;
    // minimum of 90USD is required
    uint256 public constant MIN_USD = 90e18;

    // List and store the s_funders
    address[] public s_funders;

    //owner address
    address public immutable I_OWNER;
    AggregatorV3Interface public s_priceFeed;

    //map the s_funders to the amount they fund us
    mapping(address funder => uint256 amount) public s_addressToAmount;

    //set the owner
    constructor(address priceFeed) {
        I_OWNER = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    // this function should allow users to send funds to our contract
    function sendFunds() public payable {
        if (msg.value.getConversionRate(s_priceFeed) < MIN_USD) revert Require91UsdOrMore();
        s_addressToAmount[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdrawFunds() public onlyOwner {
        //we can transfar -  payable(msg.sender).transfar(address(this).balance);
        //we can send - bool isSucess = payable(msg.sender).send(address(this).balance);
        //most apropriate way to withdraw is using call function

        (bool isSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        if (isSuccess == false) revert WithdrwalFailed();
    }

    //modifier to check if the sender is owner.
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        if (msg.sender != I_OWNER) revert NotOwner();
    }

    receive() external payable {
        sendFunds();
    }

    fallback() external payable {
        sendFunds();
    }
}
