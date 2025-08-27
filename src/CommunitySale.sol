//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;

import {MockV3Aggregator} from "../script/MockPriceFeed.sol";

contract saleContract {
    address s_owner;
    uint256 bidValue;
    uint256 constant MIM_DEPOSIT = 100e18; // Value is usd
    address[] depositors; // Array of depositors to track funders
    MockV3Aggregator priceFeed;

    struct userInfo {
        uint256 depositCount;
        uint256 amount;
    }
    //MAPPINGS

    mapping(address depositor => userInfo) deposits;
    mapping(address user => bool) whitelist;
    // mapping(address user)

    //ERRORS
    error increaseThreshold();
    error onlyOwnerFunction();
    error onceDepositAllowed();
    error onlyWhitelistedUsers();

    constructor(address _priceFeed) {
        s_owner = msg.sender;
        priceFeed = MockV3Aggregator(_priceFeed);
    }
    //Modifiers
    modifier onlyOwner() {
        if (msg.sender != s_owner) revert onlyOwnerFunction();
        _;
    }
    modifier isWhitelisted(address user) {
        if(whitelist[user] != true) revert onlyWhitelistedUsers();
        _;
    }
      
    //Functions

    function whitelistUser(address user) public onlyOwner returns(bool whitelisted){
        whitelist[user] = true;
        return whitelisted;
    }

    function depositFund() public payable isWhitelisted(msg.sender) { 
        if (conversion(msg.value) < MIM_DEPOSIT) {
            revert increaseThreshold();
        }
        if (deposits[msg.sender].depositCount > 0) revert onceDepositAllowed();
        deposits[msg.sender].amount += msg.value;
        deposits[msg.sender].depositCount += 1;
        depositors.push(msg.sender);
    }

    function getTrustUsd() public returns (uint256) {
        priceFeed = MockV3Aggregator(priceFeed); //)
        (, int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function conversion(uint256 amount) public returns (uint256) {
        uint256 trustPrice = getTrustUsd();
        uint256 amountInUsd = (trustPrice * amount) / 1e18;
        return amountInUsd;
    }

    function withdraw() public onlyOwner {
        //start withdrawal from index 1
        for (uint256 depositorIndex = 0; depositorIndex < depositors.length; depositorIndex++) {
            address depositor = depositors[depositorIndex];
            deposits[depositor].amount = 0;
        }
        // reset the depositors array to zero
        depositors = new address[](0);
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "transaction failed");
    }

    //Getter Functions
    function getOwner() public view returns (address) {
        return s_owner;
    }

    function getDepositCount(address user) public view returns (uint256 count) {
        return count = deposits[user].depositCount;
    }

    function getBalance() public view returns (uint256 bal) {
        return bal = address(this).balance;
    }
}
