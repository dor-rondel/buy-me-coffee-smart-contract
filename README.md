# WebMCP DApp PoC

This repository contains the smart contracts and frontend for the WebMCP DApp PoC. It is structured as a monorepo to separate the blockchain logic from the user interface.

## Repository Structure

- `contracts/`: Contains the Foundry project for smart contract development.
- `frontend/`: (To be added) Will contain the web application frontend.

## Smart Contracts (Foundry)

The smart contracts are built and tested using [Foundry](https://book.getfoundry.sh/). 

To work on the contracts, navigate to the `contracts/` directory:

```shell
cd contracts
```

### Build

```shell
forge build
```

### Test

```shell
forge test
```

### Deploy

```shell
forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```
