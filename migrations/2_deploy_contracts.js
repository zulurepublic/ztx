const AirDropper = artifacts.require('./AirDropper.sol');
const ZuluToken = artifacts.require('./ZuluToken.sol');

const capOnAirdropReceivers = 100000;

module.exports = function(deployer) {
    return deployer
        .then(() => {
            return deployer.deploy(AirDropper, capOnAirdropReceivers);
        })
        .then(() => {
            return deployer.deploy(ZuluToken);
        });
};
