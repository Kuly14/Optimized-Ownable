# Optimized Ownable with two step ownership transfer

Contracts like Ownable.sol from openzeppelin don't provide two step ownership transfer which can be really dangerous if you
have many millions locked in the contract.

This contract is also optimized with the use of assembly to save some gas.

You can find how much gas is saved in gas.txt

In this case it is pretty small since the these functions won't be used on a daily basis but it's still something

## To Test

1. Clone this repo;

```bash
git clone https://github.com/Kuly14/Optimized-Ownable.git
```

2. Install dependencies:

```bash
yarn
```

3. Run the tests:

```bash
yarn hardhat test
```

This will run the tests and show the gas reporter
