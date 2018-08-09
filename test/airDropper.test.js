const { should, ensuresException } = require('./helpers/utils');
const AirDropper = artifacts.require('./AirDropper.sol');
const ZuluToken = artifacts.require('./ZuluToken.sol');

const BigNumber = web3.BigNumber;

contract(
    'AirDropper',
    ([owner, buyer, buyer2, anotherOwner, zuluFoundation]) => {
        let token, airdrop;
        const tokenAmountPerAirDrop = new BigNumber(1000e18);
        const capOnAirdropReceivers = new BigNumber(2);
        const tokenAmountForContract = new BigNumber(100000000e18);

        beforeEach(async () => {
            token = await ZuluToken.new();
            airdrop = await AirDropper.new(
                capOnAirdropReceivers,
                token.address
            );
        });

        describe('AirDropper contract', () => {
            it('must not deploy when the air drop cap is null', async () => {
                try {
                    airdrop = await AirDropper.new(0, token.address);
                    assert.fail();
                } catch (e) {
                    ensuresException(e);
                }
            });

            it('must be called only by owner', async () => {
                await token.mint(airdrop.address, tokenAmountForContract);

                try {
                    await airdrop.triggerAirDrop(buyer, {
                        from: buyer
                    });
                    assert.fail();
                } catch (e) {
                    ensuresException(e);
                }

                let buyerBalance = await token.balanceOf(buyer);
                buyerBalance.should.be.bignumber.equal(0);

                const buyer2Balance = await token.balanceOf(buyer2);
                buyer2Balance.should.be.bignumber.equal(0);

                // allow when owner uses it
                await airdrop.triggerAirDrop(buyer, {
                    from: owner
                });

                buyerBalance = await token.balanceOf(buyer);
                buyerBalance.should.be.bignumber.equal(tokenAmountPerAirDrop);
            });

            it('cannot be triggered when contract has no token balance', async () => {
                try {
                    await airdrop.triggerAirDrop(buyer, {
                        from: buyer
                    });
                    assert.fail();
                } catch (e) {
                    ensuresException(e);
                }

                let buyerBalance = await token.balanceOf(buyer);
                buyerBalance.should.be.bignumber.equal(0);

                const buyer2Balance = await token.balanceOf(buyer2);
                buyer2Balance.should.be.bignumber.equal(0);
            });

            it('does not give airdrop tokens twice to same user', async () => {
                await token.mint(airdrop.address, tokenAmountForContract);

                await airdrop.triggerAirDrop(buyer2, {
                    from: owner
                });

                let buyer2Balance = await token.balanceOf(buyer2);
                buyer2Balance.should.be.bignumber.equal(tokenAmountPerAirDrop);

                try {
                    // cannot get airdrop tokens twice. See that it has the same address twice in the array
                    await airdrop.triggerAirDrop(buyer2, {
                        from: owner
                    });
                    assert.fail();
                } catch (e) {
                    ensuresException(e);
                }

                buyer2Balance = await token.balanceOf(buyer2);
                buyer2Balance.should.be.bignumber.equal(tokenAmountPerAirDrop); // amount does not change
            });

            it('sends tokens to recipients', async () => {
                await token.mint(airdrop.address, tokenAmountForContract);

                await airdrop.triggerAirDrop(buyer, {
                    from: owner
                });
                await airdrop.triggerAirDrop(buyer2, {
                    from: owner
                });

                const buyerBalance = await token.balanceOf(buyer);
                buyerBalance.should.be.bignumber.equal(tokenAmountPerAirDrop);

                const buyer2Balance = await token.balanceOf(buyer2);
                buyer2Balance.should.be.bignumber.equal(tokenAmountPerAirDrop);
            });

            it('logs TokenDrop event', async () => {
                await token.mint(airdrop.address, tokenAmountForContract);

                const { logs } = await airdrop.triggerAirDrop(buyer, {
                    from: owner
                });

                const event = logs.find(e => e.event === 'TokenDrop');

                expect(event).to.exist;
            });
        });

        describe('#kill', () => {
            it('must be called only by owner', async () => {
                await token.mint(airdrop.address, tokenAmountForContract);
                await airdrop.triggerAirDrop(buyer, {
                    from: owner
                });
                await airdrop.triggerAirDrop(buyer2, {
                    from: owner
                });

                try {
                    await airdrop.kill({
                        from: buyer
                    });
                    assert.fail();
                } catch (e) {
                    ensuresException(e);
                }

                let ownerBalance = await token.balanceOf(owner);
                ownerBalance.should.be.bignumber.equal(0);

                // allow when owner calls function
                await airdrop.kill({
                    from: owner
                });

                ownerBalance = await token.balanceOf(owner);
                ownerBalance.should.be.bignumber.equal(
                    tokenAmountForContract.minus(2000e18)
                ); // two addresses have received 1000 each in tokens
            });

            it('is callable when cap on airdrop receivers is reached', async () => {
                await token.mint(airdrop.address, tokenAmountForContract);
                await airdrop.triggerAirDrop(buyer, { from: owner });

                try {
                    await airdrop.kill({
                        from: owner
                    });
                    assert.fail();
                } catch (e) {
                    ensuresException(e);
                }

                let ownerBalance = await token.balanceOf(owner);
                ownerBalance.should.be.bignumber.equal(0);

                await airdrop.triggerAirDrop(buyer2, { from: owner });

                await airdrop.kill({
                    from: owner
                });

                ownerBalance = await token.balanceOf(owner);
                ownerBalance.should.be.bignumber.equal(
                    tokenAmountForContract.minus(2000e18)
                ); // two addresses have received 1000 each in tokens
            });
        });
    }
);
