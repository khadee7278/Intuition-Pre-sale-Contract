## README

This contract is for presale. It only allows whitelisted users to participate in the ICO.

Participants: Whitelisted users in the community
Mimimum deposit: 100USDT
Network: Trust Network
Payment Method: Trust token

This contract uses MockAggreggator for price feed. At the time of writing, Trust network has no oracle platform for price feed.


Overview

The saleContract is a simple on-chain deposit contract where whitelisted users can deposit ETH once, provided their deposit meets a minimum USD threshold. The contract uses a price feed to convert ETH deposits into USD value and ensures only eligible participants can contribute. The contract owner can later withdraw all funds.

Key Features

Whitelist Control: Only whitelisted addresses can deposit.
Single Deposit Rule: Each user can only deposit once.
Minimum Deposit: Users must deposit at least 100 USD worth of ETH.
Price Feed Integration: ETH → USD conversion powered by a mock Chainlink MockV3Aggregator.
Owner Withdrawal: Contract owner can withdraw all collected funds.

Core Parameters

MIM_DEPOSIT: 100 USD (minimum deposit).
Whitelist Required: Only approved users may deposit.
Deposit Tracking: Keeps record of depositors and amounts.

Main Functions

whitelistUser(address user): Add a user to the whitelist (only owner).
depositFund(): Deposit ETH (only once per user, must meet USD threshold).
withdraw(): Owner withdraws all ETH and resets deposits.
getTrustUsd(): Fetch latest ETH price in USD.
conversion(amount): Convert ETH amount to USD.
getDepositCount(user): Get number of times a user has deposited.
getBalance(): Check total ETH held by the contract.

Security Considerations

Only whitelisted users can deposit.
Each user can only deposit once.
Owner has full withdrawal control.

Uses mock price feed (MockV3Aggregator) — should be replaced with a real Chainlink oracle in production.

Dependencies

MockV3Aggregator (mock Chainlink price feed).

Author KHADEE


