const { assert } = require('chai');

const Store = artifacts.require('../contracts/Store.sol');

require('chai')
    .use(require('chai-as-promised'))
    .should();

contract('Store', ([deployer, seller, buyer]) => {
    let store;

    before(async () => {
        store = await Store.deployed();
    })

    describe('deployment', async () => {
        it('successful', async () => {
            const address = await store.address;

            assert.notEqual(address, 0x00);
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
        })

        it('initialized with store name and description', async () => {
            const name = await store.name();
            const description = await store.description();

            assert.equal(name, "Vela");
            assert.equal(description, "A test store for Vela Dapp");
        })
    })

    describe('poster operations', async () => {
        it('gets zero for the poster count when store is initialized', async () => {
            const count = await store.getActivePosterCount();
            assert.equal(count, 0);
        })

        it('gets empty array for the posters when store is initialized', async () => {
            const activePosters = await store.getActivePosters();
            
            activePosters.should.be.a('array');
            activePosters.should.have.length(0);
        })

        it('creates 5 new active posters', async () => {
            const currentCount = Number(await store.getActivePosterCount());

            const startDate = new Date();
            startDate.setDate(startDate.getDate() + 1);

            const endDate = new Date(startDate);
            endDate.setHours(startDate.getHours() + 3);

            const adjustedStartTime = Math.floor(startDate.getTime() / 1000);
            const adjustedEndTime = Math.floor(endDate.getTime() / 1000);

            await store.createPosters(adjustedStartTime, adjustedEndTime, true, 5);

            const posterCount = Number(await store.getActivePosterCount());
            
            assert.equal(posterCount, currentCount + 5);
        })

        it('receives 5 posters in an array', async () => {
            const posters = await store.getActivePosters();

            posters.should.be.a('array');
            posters.should.have.length(5);

            posters.forEach(poster => {
                poster.purchased.should.equal(false);
                poster.active.should.equal(true);
                poster.owner.should.equal(deployer);
            })
        })

        it('deactivates a poster using single id', async () => {
            const randId = Math.floor(Math.random() * 5);
            const prevActiveCount = Number(await store.getActivePosterCount());

            // Deactivate the poster corresponding to random id
            await store.setPostersToDeactive([randId]);

            const newActiveAcount = Number(await store.getActivePosterCount());

            // Check if the active count went down
            assert.equal(newActiveAcount, prevActiveCount - 1);

            const activePosters = await store.getActivePosters();
            console.log(randId, prevActiveCount, newActiveAcount)
            activePosters.forEach((poster, i) => {
                console.log(poster, i)
                if(i == randId) {
                    poster.active.should.equal(false);
                }
                else {
                    poster.active.should.equal(true);
                }
            })
        })
    })
})