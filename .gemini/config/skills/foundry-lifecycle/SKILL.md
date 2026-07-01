---
name: foundry-lifecycle
description: Use this skill when the user asks to compile contracts, run tests, analyze gas usage, format code, or deploy to a local/remote EVM network using Forge.
---

# Foundry Smart Contract Workflow

This skill hooks into the repository's Foundry toolchain (`forge`) to manage the compilation, testing, and deployment lifecycle of the EVM smart contracts.

## 🛠️ Environment Constraints

- **Toolchain Required:** `foundryup` (`forge`, `anvil`)
- **Project Root:** Execute all commands from the directory containing `foundry.toml`.

---

## 🏃‍♂️ Core Development Commands

### 1. Code Compilation & Artifacts

Compile the Solidity source files and generate the necessary ABIs and bytecodes:

```bash
forge build
```

### 2. Testing Suite Execution

Run the contract test suite to verify correctness and safety:

```bash
forge test
```

### 3. Gas Metrics & Analysis

Run tests while generating an inline breakdown of gas consumption per function and deployment:

```bash
forge test --gas-report
```

### 4. Code Formatting

Format all local Solidity source files (`*.sol`) to maintain style guide standards:

```bash
forge fmt
```

---

## 🚀 Local Network & Deployment Workflow

### 1. Spin Up Local Ledger (Anvil)

When debugging or deploying locally, boot a native local EVM node in an isolated terminal or background process:

```bash
anvil
```

### 2. Broadcast Local Deployment Script

Run the deployment script, sign transactions with local test keys, and broadcast them directly to the active Anvil instance:

```bash
forge script script/Deploy.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
```
