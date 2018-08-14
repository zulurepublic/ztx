const ZTX = artifacts.require('./ZTX.sol');

const { should, ensuresException } = require('./helpers/utils');

contract('ZTX', ([_, acct1]) => {
    let token;

    beforeEach(async () => {
        token = await ZTX.new();
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

    it('ztx transfer is paused', async () => {
        const paused = await token.paused();
        paused.should.be.true;

        try {
            await token.transfer(acct1, 1e18);
            assert.fail();
        } catch (error) {
            ensuresException(error);
        }
    });
});
