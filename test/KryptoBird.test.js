const { assert } = require('chai')

const KryptoBird = artifacts.require('./KryptoBird')

//check for chai
require('chai').use(require('chai-as-promised')).should()

contract('KryptoBird', (accounts) => {
  let contract
  // before tells our tests to run this first before anything else
  before(async () => {
    contract = await KryptoBird.deployed()
  })
  // testing container - describe
  describe('deployment', async () => {
    // test samples with writing it
    it('deploys successfuly', async () => {
      const address = contract.address
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
      assert.notEqual(address, 0x0)
    })

    it('Name matches the contract', async () => {
      let name = await contract.name()
      assert.equal(name, 'KryptoBird')
    })
    it('Symbol matches the contract', async () => {
      let symbol = await contract.symbol()
      assert.equal(symbol, 'KBIRDZ')
    })
  })

  describe('mint', async () => {
    // test samples with writing it
    it('creates a new token', async () => {
      const result = await contract.mint('https..1')
      const totalSupply = await contract.totalSupply()
      const event = result.logs[0].args

      console.log('Total Supply = ', totalSupply)
      console.log('Total Supply (words[0]) = ', totalSupply.words[0])
      console.log('Total Supply (.length) = ', totalSupply.length)

      //sucess
      assert.equal(totalSupply.length, 1)

      assert.equal(
        event._from,
        '0x0000000000000000000000000000000000000000',
        'from the contract',
      )
      console.log('_from = 0x0000000000000000000000000000000000000000')

      assert.equal(event._to, accounts[0], 'to is the msg.sender')
      console.log('_to = msg.sender')

      // Failure
      await contract.mint('https..1').should.be.rejected
    })
  })

  describe('indexing', async () => {
    // test samples with writing it
    it('lists KryptoBirdz', async () => {
      // Minting more tokens
      await contract.mint('https..2')
      await contract.mint('https..3')
      await contract.mint('https..4')
      await contract.mint('https..5')
      const totalSupply = await contract.totalSupply()

      // Loop through list and grab KBirdz

      let result = []
      let KryptoBird
      console.log('totalSupply ', totalSupply.words[0]);
      for (let index = 1; index <= totalSupply.words[0]; index++) {
        KryptoBird = await contract.kryptoBirdz(index - 1)
        console.log('KryptoBird ', KryptoBird)
        result.push(KryptoBird)
      }

      let expected = [
        'https..1',
        'https..2',
        'https..3',
        'https..4',
        'https..5'
      ]
      assert.equal(result.join(','), expected.join(','))
    })
  })
})
