# Buy Me A Coffee

A full-stack project featuring a Solidity smart contract for receiving donations and a responsive Svelte frontend.

**Live Website:** [https://dor-rondel.github.io/buy-me-coffee-smart-contract/](https://dor-rondel.github.io/buy-me-coffee-smart-contract/)

## Project Structure

- **/contracts**: Solidity smart contract code.
- **/frontend**: Svelte-based frontend application.

## Frontend

### Getting Started

Ensure you have [pnpm](https://pnpm.io/) or alternative node package manager installed.

1. Navigate to the `frontend` directory:

   ```bash
   cd frontend
   ```

2. Install the dependencies:

   ```bash
   pnpm install
   ```

3. Start the development server:
   ```bash
   pnpm run dev
   ```

### UI & Styling

- **Theme**: Modern "glass-morphism" aesthetic with an Ubuntu-inspired orange gradient palette.
- **Responsiveness**: Fully responsive design, centered horizontally and vertically on all screen sizes.

### Active Smart Contract Deployments

| Network   | Chain ID | Contract Address                             |
| :-------- | :------- | :------------------------------------------- |
| Sepolia   | 11155111 | `0xfD6C8Ee5193B111aABc5a2D8925a45fF11eBc0f4` |
| Localhost | 31337    | `0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512` |

## CI/CD

- **Smart Contracts**: CI runs automatically on changes to `contracts/`, `script/`, or `foundry.toml`.
- **Frontend**: Automatically deploys to GitHub Pages on `main` branch merges from `frontend/` directory.
  Automatically type-checks, lint checks, and build checks on new PRs in `frontend/` directory.

## Project Context

For more architectural details, conventions, and workflows, please refer to the [GEMINI.md](.gemini/GEMINI.md) file.

## Smart Contract Features

- **Minimum Contribution**: Enforces a minimum donation amount in USD (using Chainlink Price Feeds) to optimize gas costs by ensuring transactions are meaningful.
- **Donor Tracking**: Stores a record of all donors, including their address, message, timestamp, and contribution amount.
- **Ownership**: Only the contract owner can withdraw collected funds.
- **Message Support**: Allows donors to include a message (max 200 characters) with their contribution.
