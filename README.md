# Buy Me a Coffee DApp

This repository contains the smart contracts for a basic "Buy me a coffee" / "Send me money" DApp, built specifically to be deployed on the **zkSync Mainnet Layer 2** to minimize transaction costs.

## Features
- **Minimum Contribution**: The contract enforces a minimum contribution amount of $3 USD.
- **Chainlink Oracle Integration**: Uses Chainlink Data Feeds (Decentralized Oracle Networks) for real-time ETH/USD price conversion to validate the minimum spend.
- **Donor Tracking**: Maintains a record of donors, including their address, a custom message (up to 200 characters), timestamp, and donation amount.
- **Owner Withdrawal**: Secure mechanism for the contract owner to withdraw collected funds.

## Design Decisions
- **No Events/Mappings**: We have deliberately omitted Events and complex Mappings (e.g., address-to-donations) to keep the `fund` function as gas-efficient as possible. Given the expected low volume and lack of subscription features, the current array-based tracking is sufficient for frontend needs.
- **Minimalist Storage**: Storing only essential donor data to minimize on-chain footprint.
- **Immutability of Owner & Oracle**: Both the contract owner and the Chainlink Price Feed address are immutable once deployed. This eliminates "privileged access" risks but requires the owner to secure their private keys, as there is no recovery mechanism. We rely on Chainlink's proxy pattern for oracle longevity.

## Smart Contracts (Foundry)

The smart contracts are built and tested using [Foundry](https://book.getfoundry.sh/). 

To work on the contracts, run commands from the project root directory.

### Build

```shell
forge build
```

### Local Testing with Anvil

To run a persistent local node and deploy to it using the configured mock contracts:

1. Copy `.env.example` to `.env` and ensure your `PRIVATE_KEY` is set.

2. Open a separate terminal and start Anvil with EIP-1559 base fee disabled to avoid gas price issues:
   ```shell
   anvil --no-base-fee
   ```
3. Load the environment variables and run the deployment script targeting the local network:
   ```shell
   source .env
   forge script contracts/script/BuyMeACoffee.s.sol --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY --broadcast
   ```
### Test

```shell
forge test
```

### Future Requirements
- **Environment Helper Functions:** As the project evolves, we will need helper functions to seamlessly switch between different networks, including `sepolia` mainnet, `zksync` sepolia, and `zksync` mainnet.

## Project Guidelines
Please refer to the `.gemini/GEMINI.md` for strict coding guidelines (style, optimization, and naming conventions) utilized by developers and Antigravity agents on this project.
