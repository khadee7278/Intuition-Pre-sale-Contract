//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../script/MockPriceFeed.sol";
import {saleContract} from "../src/CommunitySale.sol";

contract DeployCommunitySale is Script {
    saleContract sale;
    address priceFeed;
    MockV3Aggregator mockFeed;

    function run() external returns (saleContract) {
        vm.startBroadcast();
        mockFeed = new MockV3Aggregator(8, 1e8);
        new saleContract(priceFeed);
        vm.stopBroadcast();
        return (sale);
    }
}

