#!/usr/bin/env bash

rm -rf flats/*

./node_modules/.bin/truffle-flattener contracts/Airdropper.sol > flats/Airdropper.sol
./node_modules/.bin/truffle-flattener contracts/ZTX.sol > flats/ZTX.sol
