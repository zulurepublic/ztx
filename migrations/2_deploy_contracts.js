const MintableAirDropper = artifacts.require("./MintableAirDropper.sol");
const ZTX = artifacts.require("./ZTX.sol");

const capOnAirdropReceivers = 100000;
const tokenAmountPerAirDrop = 1000e18;

module.exports = function(deployer) {
  return deployer
    .then(() => {
      return deployer.deploy(ZTX);
    })
    .then(() => {
      return deployer.deploy(
        MintableAirDropper,
        capOnAirdropReceivers,
        tokenAmountPerAirDrop,
        ZTX.address
      );
    });
};
