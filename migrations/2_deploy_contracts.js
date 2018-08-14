const AirDropper = artifacts.require('./AirDropper.sol');
const ZTX = artifacts.require('./ZTX.sol');

const capOnAirdropReceivers = 100000;

module.exports = function(deployer) {
    return deployer
        .then(() => {
            return deployer.deploy(ZTX);
        })
        .then(() => {
            return deployer.deploy(
                AirDropper,
                capOnAirdropReceivers,
                ZTX.address
            );
        });
};
