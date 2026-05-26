# Send Me Money / Buy Me a Coffee DApp

This repository contains the smart contracts for a basic "Buy me a coffee" / "Send me money" DApp, built specifically to be deployed on the **zkSync Mainnet Layer 2** to minimize transaction costs.

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

### Future Requirements
- **Environment Helper Functions:** As the project evolves, we will need helper functions to seamlessly switch between different networks, including `sepolia` mainnet, `zksync` sepolia, and `zksync` mainnet.

## Project Guidelines
Please refer to the `.gemini/GEMINI.md` for strict coding guidelines (style, optimization, and naming conventions) utilized by developers and Antigravity agents on this project.
