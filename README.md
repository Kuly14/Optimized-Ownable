# Optimized Ownable with two step ownership transfer

Contracts like Ownable.sol from openzeppelin don't provide two step ownership transfer which can be really dangerous if you
have many millions locked in the contract.

This contract is also optimized with the use of assembly to save some gas.

You can find how much gas is saved in gas.txt

In this case it is pretty small since the these functions won't be used on a daily basis but it's still something
