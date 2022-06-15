// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 < 0.9.0;

contract HelloWorld{

    // public so no need for a getter
    string public message;

    // constructor
    constructor() {
        message = "Hello World";
    }

    // setter
    function setMessage (string memory _message) public {
        message = _message;
    }

}