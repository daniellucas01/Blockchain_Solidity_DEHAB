const TruffleProvider = require ('truffle-hdwallet-provider');
const Web3 = require('web3');
const {interface , bytecode } = require('./compile');

const provider = new TruffleProvider(
    'wrestle celery slender fine fetch eagle bring trust country charge time list', 
    'https://rinkeby.infura.io/v3/1c87174ef80345fb92acbd2da20133e5'
);

const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();
    console.log('Attempting to deploy from account', accounts[0]);

    const result = await new web3.eth.Contract(JSON.parse(interface))
        .deploy({data: '0x' + bytecode, arguments: ['Hi there!']}) // add 0x bytecode
        .send({from: accounts[0]});

        console.log('Contract deployed to', result.options.address);
};
deploy();
