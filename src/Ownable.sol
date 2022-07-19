// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.7;

/// @author Kuly14

/**
 * Optimized Ownable contract with a two step ownership transfer process.
 * To change the owner the current owner has to call tranferOwnership with the new address
 * and the new owner has to claim the ownership by calling claimOwnership before it's accepted
 */

contract Ownable {
    event TransferOwnershipProposed(address _newOwner);
    event OwnershipTransfered(address _newOwner);

    address public owner;
    address public pendingOwner;

    error notOwner(address _sender);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert notOwner(msg.sender);
        }
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        bytes32 eventHash = bytes32(
            keccak256("TransferOwnershipProposed(address)")
        );

        assembly {
            sstore(1, newOwner)

            mstore(0x80, newOwner)

            log1(0x80, 32, eventHash)
        }
    }

    function claimOwnership() public {
        bytes32 eventHash = bytes32(keccak256("OwnershipTransfered(address)"));
        assembly {
            let pending := sload(1)
            if iszero(eq(caller(), pending)) {
                revert(0, 0)
            }

            sstore(0, pending)
            sstore(1, 0x00)

            mstore(0x80, pending)
            log1(0x80, 32, eventHash)
        }
    }
}
