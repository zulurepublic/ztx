const ZuluToken = artifacts.require('./ZuluToken.sol');

const { should } = require('./helpers/utils');

contract('ZuluToken', () => {
    let token;

    beforeEach(async () => {
        token = await ZuluToken.new();
    });

    it('has a name', async () => {
        const name = await token.name();
        name.should.be.equal('Zulu Republic Token');
    });

    it('possesses a symbol', async () => {
        const symbol = await token.symbol();
        symbol.should.be.equal('ZTX');
    });

    it('contains 18 decimals', async () => {
        const decimals = await token.decimals();
        decimals.should.be.bignumber.equal(18);
    });
});
