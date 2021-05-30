const TimeWiz = artifacts.require('../contracts/TimeWiz.sol');

require('chai')
    .use(require('chai-as-promised'))
    .should();

contract('TimeWiz', () => {
    let wiz;

    before(async () => {
        wiz = await TimeWiz.deployed();
    })

    describe('Checks the time operations', async () => {
        
    })
})