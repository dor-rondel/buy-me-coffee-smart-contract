---
name: web3-git-workflow
description: Use this skill when running local pre-commit checks (compile, format, test), analyzing contract changes, committing smart contract updates, or pushing to GitHub.
---

# Web3 Git Commit & Push Workflow

This skill hooks the Forge smart contract development verification directly into the Git workflow, ensuring no broken Solidity code or unformatted contracts get pushed to the remote repository.

## 🛠️ Toolchain Prerequisites

- **EVM Framework:** `forge` (Foundry)
- **Project Root:** Run all commands from the directory containing `foundry.toml`.

---

## 🏃‍♂️ Step 1: Pre-Commit Contract Verification

Execute these verification checks in order. **Stop the workflow immediately if any check fails.**

| Step | Task                     | Command       | Target / Standard                         |
| :--- | :----------------------- | :------------ | :---------------------------------------- |
| 1    | **Code Formatting**      | `forge fmt`   | Enforces Solidity style guide layouts     |
| 2    | **Contract Compilation** | `forge build` | Verifies the code compiles without errors |
| 3    | **Smart Contract Tests** | `forge test`  | Executes local unit and integration tests |

---

## 🔍 Step 2: Stage & Diff Analysis

Once the code passes all local Forge checks, review exactly what changes are being prepared for the commit.

1. **Check Workspace Status:**

```bash
git status
```

2. **Stage Changes:**

```bash
   git add .
```

3. **Review Staged Changes:** Run the following command to review the precise lines added or modified in the contracts:

```bash
   git diff --cached
```

- **Agent Instruction:** Carefully analyze the structural modifications to the smart contracts or test files in this diff to formulate a highly accurate, precise commit message.

---

## 🔀 Step 3: Git Commit & Push

Only proceed to this step after all pre-commit contract checks have passed and the staged diff has been reviewed.

1. **Commit with Context:**
   - Craft a concise, clear commit message using the imperative mood (e.g., `feat: add memo validation to buyMeCoffee function`).
   - Base the description directly on your findings from the `git diff --cached` output.
     ```bash
     git commit -m "<descriptive-message-from-diff>"
     ```

2. **Push to Remote:**

```bash
   git push origin HEAD
```
