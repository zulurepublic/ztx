# Zulu Republic's ZTX

![Zulu Republic](zulu-icon.png)

## Table of Contents

-   [Table of Contents](#table-of-contents)
-   [Overview](#overview)
-   [Implementation Details](#implementation-details)
-   [Development](#development)
-   [Setting Up](#setting-up)
-   [Running Tests](#running-tests)
-   [Test Coverage](#test-coverage)

## Overview

The ZuluToken(ZTX) contract is a standard ERC20 token. This repository also includes the Airdropper contract which distributes ZTX to the first 100 thousand Zulu Republic citizens.

## Implementation Details

-   Airdropper.sol

This contract distributes ZTX in the token's initial distribution phase. The first 100 thousand Zulu Republic citizens receive 1000 ZTX.

`triggerAirDrop` is the main function that distributes tokens to recipient addresses. You pass a recipient and she gets the ZTX tokens. A user who claimed their ZTX airdropped tokens cannot do so again.

-   ZuluToken.sol

Standard ERC20 token contract. It possesses the [ERC20 functions](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md).

## Development

**Dependencies**

-   `node@9.5.x`

## Setting Up

-   Clone this repository.

-   Install all [system dependencies](#development).

    -   `npm install`

-   Compile contract code

    -   `node_modules/.bin/truffle compile`

## Running Tests

-   `npm run test`

## Test Coverage

To see current test coverage, open `coverage/index.html` in a browser.

To generate test coverage, type:

-   `npm run cov`
