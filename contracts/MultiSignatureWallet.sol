pragma solidity ^0.4.0;
contract MultiSignatureWallet {
    address private _owner;
    mapping(address => uint8) private _owners;

    uint constant MINIMUM_SIGNATURES = 2;
    uint private _transactionIdx;

    mapping (uint => Transaction) private _transactions;
    uint[] private _pendingTransactions;

    struct Transaction {
        address from;
        address to;
        uint amount;
        uint signatureCount;
        mapping (address => uint8) signatures;
    }

    constructor (address owner1, address owner2) public{
        _owner = msg.sender;
        _owners[owner1] = 1;
        _owners[owner2] = 1;
    }


    //3 Valid Keys
    modifier isOwner() {
        require(
            msg.sender == _owner,
            "Sender is not authorized."
        );
        _;
    }

    modifier validOwner() {
        require(msg.sender == _owner || _owners[msg.sender] == 1,
        "Sender is not a valid owner"
        );
        _;
    }

    //Transaction Functions
    function getPendingTransactions() public view validOwner returns (uint[] memory){
        return _pendingTransactions;
    }

    function signTransaction(uint transactionId) public validOwner {
        Transaction storage transaction = _transactions[transactionId];
        //Transaction must exist
        require (0x0 != transaction.from);
        require (transaction.signatures[msg.sender] != 1);

        transaction.signatures[msg.sender] = 1;
        transaction.signatureCount ++;

        //Put event here

        if(transaction.signatureCount >= MINIMUM_SIGNATURES) {
            require(address(this).balance >= transaction.amount);
            transaction.to.transfer(transaction.amount);
            deleteTransaction(transactionId);
            //Continue to delete transaction once done
        }
    }

    function deleteTransaction(uint transactionId) public validOwner{
      uint8 replace = 0;
      for(uint i = 0; i < _pendingTransactions.length; i++) {
        if (1 == replace) {
          _pendingTransactions[i-1] = _pendingTransactions[i];
        } else if (transactionId == _pendingTransactions[i]) {
          replace = 1;
        }
      }
      delete _pendingTransactions[_pendingTransactions.length - 1];
      _pendingTransactions.length--;
      delete _transactions[transactionId];
    }

    //Payable Functions

    function deposit() external payable validOwner {
    }

    function transferTo(uint amount, address receiverAddress) public validOwner{
        require(
            address(this).balance >= amount,
            "Amount is insufficient"
        );
        receiverAddress.transfer(amount);
    }

    function getWalletBallance() public view returns (uint) {
      return address(this).balance;
    }
}