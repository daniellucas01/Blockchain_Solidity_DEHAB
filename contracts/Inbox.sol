pragma solidity >=0.4.22 <0.7.0;

contract Inbox {
    string public message;

    constructor (string _initialMessage) public{
        message = _initialMessage;
    }

    function setMessage (string newMessage) public{
        message = newMessage;
    }
}