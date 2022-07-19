// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.7;

import "./Ownable.sol";

contract TestContract is Ownable {
    address public user;

    function changeUser(address _newUser) public onlyOwner {
        user = _newUser;
    }
}
