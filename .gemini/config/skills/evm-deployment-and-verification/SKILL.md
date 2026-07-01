---
name: evm-deployment-and-verification
description: Use this skill when deploying to live testnets/mainnets, verifying source code on block explorers, or exporting ABIs for frontend integration.
---

# EVM Live Deployment, Verification, & Artifact Export

This skill covers the production-ready steps required to take compiled contracts and safely bridge them to live networks and frontend user interfaces.

## 🛠️ Security Prerequisites

- **Environment Variables:** Ensure `.env` contains valid keys before execution:
  - `PRIVATE_KEY`: The deploying wallet's secret key.
  - `RPC_URL`: The target network node provider URL (e.g., Base, Arbitrum, Sepolia).
  - `ETHERSCAN_API_KEY`: API key for automated explorer source code verification.

---

## 🏃‍♂️ Advanced Network Deployment

### 1. Testnet/Mainnet Deployment & Verification

Deploy the contract to a live network using environment variables, and automatically submit the source code to Etherscan/Blockscout for verification in a single run:
forge script script/Deploy.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY

### 2. Standalone Verification

If a deployment went through but verification timed out, manually verify the contract post-deployment:
forge verify-contract <deployed-address> src/BuyMeACoffee.sol:BuyMeACoffee --etherscan-api-key $ETHERSCAN_API_KEY --rpc-url $RPC_URL

---

## 📐 Frontend Integration Artifacts

### 1. Locate the ABI

When the frontend app needs to talk to the deployed contract, the exact JSON contract interface can be extracted from the Forge build artifacts directory:
cat out/BuyMeACoffee.sol/BuyMeACoffee.json | jq '.abi'

### 2. Sync ABIs to Frontend

If this repository includes a frontend folder or take-home client assignment, copy the fresh ABI directly into the web client asset path:
cp out/BuyMeACoffee.sol/BuyMeACoffee.json ../frontend/src/abis/
