
//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {saleContract} from "../src/CommunitySale.sol";
import {DeployCommunitySale} from "../script/DeployCommunitySale.s.sol";

contract communitySaleTest is Test {
   saleContract sale;
   DeployCommunitySale deployer;

    address user = makeAddr("user");

    function setUp() external {
        vm.deal(user, 100 ether);
        deployer = new DeployCommunitySale();
        sale = deployer.run();
    }

    function testOwner() external view {
        assertEq(sale.getOwner(), msg.sender);
    }

    function testDeposit() external {
        vm.startPrank(user);
       vm.expectRevert(saleContract.increaseThreshold.selector);
        sale.depositFund{value: 0.001 ether}();
        vm.stopPrank();
    }

    function testMinDeposit() external {
        uint256 amountInUsd = sale.conversion(100e18);
        uint256 ethPrice = sale.getTrustUsd();
        console.log(amountInUsd);
        console.log(ethPrice);
    }

    function testDepositCount() external {
        uint256 sendCount = sale.getDepositCount(user);
        vm.expectRevert(saleContract.onceDepositAllowed.selector);
        vm.startPrank(user);
        sale.depositFund{value: 0.1 ether}();
        vm.stopPrank();
        assertEq(sendCount, 0);
    }

    modifier deposit() {
        vm.startPrank(user);
        sale.depositFund{value: 0.1 ether}();
        _;
    }

    function testDoubleDeposit() external deposit {
        uint256 sendCount = sale.getDepositCount(user);
        vm.expectRevert(saleContract.onceDepositAllowed.selector);
        vm.startPrank(user);
        sale.depositFund{value: 0.5 ether}();
        vm.stopPrank();
        console.log(sendCount);
    }

    function testWithdraw() external {
        // using uint160 to generate addresses due to hoax cheat code
        uint160 funderIndex = 10;
        for (uint160 i = 0; i < funderIndex; i++) {
            hoax(address(i), 1 ether);
            sale.depositFund{value: 0.1 ether}();
        }
        uint256 bal = sale.getBalance();
        console.log(bal);
        vm.startPrank(sale.getOwner());
        sale.withdraw();
        bal = sale.getBalance();
        console.log(bal);
        vm.stopPrank();
        assertEq(address(sale).balance, 0);
    }
}
