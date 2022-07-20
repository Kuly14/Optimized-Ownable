// SPDX-License-Identifier: MIT
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
        // Get the eventHash
        bytes32 eventHash = bytes32(
            keccak256("TransferOwnershipProposed(address)")
        );

        assembly {
            // Store the newOwner at slot 1 where the pendingOwner is stored
            sstore(1, newOwner)

            // Store newOwner to memory so we can emit the data
            mstore(0x80, newOwner)

            // Emit the data stored at memory address 0x80, with length of 32 bytes
            log1(0x80, 32, eventHash)
        }
    }

    function claimOwnership() public {
        // Get the eventHash
        bytes32 eventHash = bytes32(keccak256("OwnershipTransfered(address)"));
        assembly {
            // Load pendingOwner from storage to the stack
            let pending := sload(1)

            // Check if the caller is the pending owner
            if iszero(eq(caller(), pending)) {
                // Revert if not
                revert(0, 0)
            }

            // Store pendingOwner to memory from stack
            mstore(0x80, pending)

            // Store pending owner at the 0th slot. So owner = pendingOwner
            sstore(0, pending)

            // Change the pending owner address to address(0) and get a gas refund
            sstore(1, 0x00)

            // Emit the event
            log1(0x80, 32, eventHash)
        }
    }
}
