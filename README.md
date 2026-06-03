# Buy Me A Coffee Smart Contract

This project contains a Solidity smart contract to receive donations (coffee) and a Svelte-based frontend to interact with the contract.

## Frontend
The frontend is a Svelte application located in the `frontend/` directory.

### UI & Styling
- **Theme**: Modern "glass-morphism" aesthetic with an Ubuntu-inspired orange gradient palette.
- **Responsiveness**: Fully responsive design, centered horizontally and vertically on all screen sizes.
- **User Experience**: Includes robust input sanitization to block negative numbers and non-numeric characters, along with improved error handling for transaction states.

## CI/CD
- **Smart Contracts**: CI runs automatically on changes to `contracts/`, `script/`, or `foundry.toml`.
- **Frontend**: Separate CI pipeline for `frontend/` triggers on relevant changes, performing linting, type-checking, and building.

## Development
- **Linting**: ESLint is configured for the frontend. Run `pnpm lint` in the `frontend/` directory.
