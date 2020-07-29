const assert = require ('assert');
const ganache = require ('ganache-cli');
const Web3 = require ('web3');
const web3 = new Web3(ganache.provider()); // Ganache Provider
const {interface, bytecode} = require('../compile');
const NEW_MESSAGE = 'Hi i am Daniel, the awesome one!'

let accounts;
let inbox_contract;

beforeEach(async () => {
    //Before every execution
    //Get a list of all accounts
    accounts = await web3.eth.getAccounts(); // Async

    //use one account to deploy the contract
    inbox_contract = await new web3.eth.Contract(JSON.parse(interface))
    .deploy(
        {
            data : bytecode, 
            arguments: ['I am awesome'] 
        })
    .send({from: accounts[0], gas: '1000000'});
});

describe('Inbox' , () => {
    it('deploys a contract', () => {
        assert.ok(inbox_contract.options.address);
    });

    it('has a default message', async () => {
        const message = await inbox_contract.methods.message().call();
        assert.equal(message, 'I am awesome')
    });

    it('can change the message', async () => {
        await inbox_contract.methods.setMessage(NEW_MESSAGE).send({ from: accounts[0] });
        const message = await inbox_contract.methods.message().call();
        assert.equal(message, NEW_MESSAGE);
    });

    
});