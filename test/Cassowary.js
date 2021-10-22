const Cassowary = artifacts.require("Cassowary");

async function sleep(milliseconds) {
    const date = Date.now();
    let currentDate = null;
    do {
      currentDate = Date.now();
    } while (currentDate - date < milliseconds);
  }
let day =60;

contract('Cassowary', (accounts) => {
  let cassowary,timestamp

  before(async () => {
    cassowary = await Cassowary.deployed()
    timestamp=Date.now();
    timestamp=timestamp-timestamp%(day*1000);
  })

  describe('deployment', async () => {
    it('deploys successfully', async () => {
      const address = await cassowary.address
      assert.notEqual(address, 0x0)
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
    })

    it('has a name', async () => {
      const name = await cassowary.name()
      assert.equal(name, 'Cassowary')
    })
    it('has a symbol', async () => {
      const name = await cassowary.symbol()
      assert.equal(name, 'CSR')
    })
    it('has a timestamp created', async () => {
      const timestampCreated = await cassowary.timestampCreated()
      assert.equal((timestamp/1000).toString(), timestampCreated.toString())
    })
    it('has a owner', async () => {
        const owner = await cassowary.owner()
        assert.equal(accounts[0],owner)
      })
  })
  describe('mint, transfer , burn', async () => {
      it('mint and transfer',async () => {
        await cassowary.mint(accounts[1],365*5*20,{from:accounts[0]})
        await sleep(day*1000-(timestamp-Date.now()))
        let balance = await cassowary.balanceOf(accounts[1]);
        console.log(balance);
        //assert.equal((20).toString(), balance.toString())
        await cassowary.transfer(accounts[0],10,{from:accounts[1]})
        balance = await cassowary.balanceOf(accounts[1]);
        
        console.log(balance);
        assert.equal((10).toString(), balance.toString())
        balance = await cassowary.balanceOf(accounts[0]);

        await cassowary.transfer(accounts[0],10,{from:accounts[1]})
      })
      it('burn',async () => { 
        await cassowary.burn(10,{from:accounts[1]})
        balance = await cassowary.balanceOf(accounts[1]);
        console.log(balance);
        assert.equal((10).toString(), balance.toString())
        balance = await cassowary.balanceOf(accounts[0]);
        await cassowary.transfer(accounts[0],10,{from:accounts[1]})
      })

      
  })
});
