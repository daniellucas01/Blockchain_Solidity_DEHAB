pragma solidity >=0.4.22 <0.7.0;
contract MultiSignatureWallet {
    address private _owner;
    mapping(address => uint8) private _owners;

    //3 Valid Keys
    modifier isOwner() {D
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
    function containsAnotherKey(address _anotherKey) private view returns (bool) {
        //Cannot abuse the same key pair
        if ( _anotherKey == msg.sender )
        {
            return false;
        }
        //Check the validity of the key pair
        if ( _anotherKey == _owner || _anotherKey == _owners[msg.sender] )
        {
            return true;
        }
        else {
            return false;
        }
    }

    function deposit(uint amount, address validKey) public payable validOwner {
        require(
            containsAnotherKey(validKey) == true,
            "Key is not valid"
        );
        require(
            msg.value == amount,
            "Insufficient funds"
        );
        msg.sender.transfer(amount);
    }

    function transferTo(uint amount, address validKey, address receiverAddress) public validOwner{
        require(
            containsAnotherKey(validKey) == true,
            "Key is not valid"
        );
        require(
            address(this).balance >= amount,
            "Amount is insufficient"
        );
        receiverAddress.transfer(amount);
    }
}