<script lang="ts">
  import { ethers } from "ethers";
  import { getContract } from "$lib/services/contractService";
  import { onMount } from "svelte";

  let amount = "0.01";
  let message = "";
  let status = "";
  let funders: { donor: string }[] = [];

  async function fetchDonors() {
    if (!window.ethereum) return;
    try {
      const chainId = (
        await window.ethereum.request({ method: "eth_chainId" })
      ).toString();
      const decimalChainId = parseInt(chainId, 16).toString();
      const contract = await getContract(decimalChainId);
      const data = await contract.getDonors();
      funders = Array.from(data);
    } catch (e) {
      console.error("Error fetching donors:", e);
    }
  }

  onMount(fetchDonors);

  async function handleFund() {
    if (!window.ethereum) {
      status = "Please install MetaMask";
      return;
    }

    try {
      const chainId = (
        await window.ethereum.request({ method: "eth_chainId" })
      ).toString();
      const decimalChainId = parseInt(chainId, 16).toString();

      const contract = await getContract(decimalChainId);

      const numAmount = parseFloat(amount);
      if (isNaN(numAmount) || numAmount <= 0) {
        status = "Error: Amount must be a positive number";
        return;
      }

      const value = ethers.parseEther(amount.toString());

      status = "Sending transaction...";

      // We add a manual gas limit to bypass MetaMask's estimation error
      // if it's being flaky, while still allowing the transaction to proceed.
      // 150,000 is plenty for this function.
      const tx = await contract.fund(message, {
        value,
        gasLimit: 150000,
      });

      await tx.wait();

      status = "Transaction successful!";
      message = "";
      await fetchDonors();
    } catch (e: unknown) {
      console.error("Detailed error:", e);
      const error = e as { code?: string; reason?: string; message?: string };
      if (error.code === "INSUFFICIENT_FUNDS") {
        status = "Error: Insufficient funds for transaction";
      } else if (error.code === "ACTION_REJECTED") {
        status = "Transaction rejected by user";
      } else {
        status = `Error: ${error.reason || error.message || "Unknown error"}`;
      }
    }
  }
</script>

<div class="glass-card">
  <h2>😇 Support Dor 😇</h2>

  <label>
    Amount (ETH):
    <input
      type="number"
      bind:value={amount}
      step="0.01"
      min="0"
      on:keydown={(e: KeyboardEvent) => {
        if (e.key === "-") {
          e.preventDefault();
        }
      }}
      on:input={(e: Event) => {
        const target = e.target as HTMLInputElement;
        if (parseFloat(target.value) < 0) {
          amount = "0";
          target.value = "0";
        }
      }}
    />
  </label>

  <label>
    Message (max 200):
    <textarea
      bind:value={message}
      maxlength="200"
      placeholder="Optional message..."
    ></textarea>
    <span class="char-count">{message.length}/200</span>
  </label>

  <button on:click={handleFund}>Send ETH 💌</button>

  {#if status}
    <p
      class="status"
      class:error={status.includes("Error") || status.includes("rejected")}
      class:success={status.includes("successful")}
    >
      {status}
    </p>
  {/if}
</div>

{#if funders.length > 0}
  <div class="funders-list glass-card">
    <h3>Recent Funders</h3>
    <ul>
      {#each [...funders].slice(-3).reverse() as funder, i (i)}
        <li>{funder.donor.slice(0, 6)}...{funder.donor.slice(-4)}</li>
      {/each}
    </ul>
  </div>
{/if}

<style>
  :global(body) {
    background-color: #0f0f0f;
    background-image: radial-gradient(
        at 0% 0%,
        rgba(255, 140, 0, 0.15) 0px,
        transparent 50%
      ),
      radial-gradient(at 100% 0%, rgba(255, 69, 0, 0.1) 0px, transparent 50%);
    min-height: 100vh;
    margin: 0;
    font-family:
      "Inter",
      -apple-system,
      BlinkMacSystemFont,
      "Segoe UI",
      Roboto,
      sans-serif;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
    padding: 2rem;
  }

  :global(#app) {
    min-width: 380px;
    width: 100%;
    max-width: 450px;
  }

  .glass-card {
    background: rgba(25, 25, 25, 0.8);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    /* Gradient Border */
    border: 2px solid transparent;
    background-clip: padding-box, border-box;
    background-origin: padding-box, border-box;
    background-image: linear-gradient(
        to right,
        rgba(25, 25, 25, 0.8),
        rgba(25, 25, 25, 0.8)
      ),
      linear-gradient(to bottom right, #ff8c00, #ff4500);
    padding: 2rem;
    border-radius: 1.5rem;
    color: #fff;
    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
    animation: slideUp 0.5s ease-out;
    width: 100%;
    box-sizing: border-box;
  }

  .funders-list {
    margin-top: 1.5rem;
    padding: 1.5rem;
  }

  .funders-list h3 {
    margin-top: 0;
    color: #ff8c00;
    font-size: 1.2rem;
    text-align: center;
    margin-bottom: 1rem;
  }

  .funders-list ul {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .funders-list li {
    font-family: monospace;
    background: rgba(0, 0, 0, 0.2);
    padding: 0.5rem;
    border-radius: 0.5rem;
    margin-bottom: 0.5rem;
    text-align: center;
    font-size: 0.9rem;
  }

  @keyframes slideUp {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  @media (max-width: 480px) {
    .glass-card {
      padding: 1.5rem;
      border-radius: 1.25rem;
    }

    h2 {
      font-size: 1.5rem;
    }
  }

  h2 {
    margin-top: 0;
    margin-bottom: 1.5rem;
    font-size: 1.75rem;
    font-weight: 800;
    background: linear-gradient(45deg, #ff8c00, #ff4500);
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
    letter-spacing: -0.02em;
    text-align: center;
  }

  label {
    display: block;
    margin-bottom: 1.25rem;
    font-weight: 600;
    font-size: 0.9rem;
    color: #aaa;
  }

  input,
  textarea {
    display: block;
    width: 100%;
    margin-top: 0.5rem;
    background: rgba(0, 0, 0, 0.3);
    color: #fff;
    border: 1px solid rgba(255, 140, 0, 0.5);
    padding: 0.75rem;
    border-radius: 0.75rem;
    font-size: 1rem;
    transition: all 0.2s ease;
    box-sizing: border-box;
  }

  input:focus,
  textarea:focus {
    outline: none;
    border-color: #ff8c00;
    background: rgba(0, 0, 0, 0.5);
    box-shadow: 0 0 0 4px rgba(255, 140, 0, 0.1);
  }

  textarea {
    resize: none;
    min-height: 200px;
    line-height: 1.5;
  }

  .char-count {
    display: block;
    text-align: right;
    margin-top: 0.25rem;
    font-size: 0.75rem;
    color: #666;
  }

  button {
    width: 100%;
    background: linear-gradient(45deg, #ff8c00, #ff4500);
    color: #fff;
    border: none;
    padding: 1rem;
    border-radius: 0.75rem;
    font-weight: 700;
    font-size: 1rem;
    cursor: pointer;
    transition:
      transform 0.1s active,
      opacity 0.2s,
      box-shadow 0.2s;
    margin-top: 0.5rem;
    box-shadow: 0 4px 15px rgba(255, 69, 0, 0.3);
  }

  button:hover {
    opacity: 0.9;
    box-shadow: 0 6px 20px rgba(255, 69, 0, 0.4);
    transform: translateY(-1px);
  }

  button:active {
    transform: translateY(0);
  }

  .status {
    margin-top: 1.5rem;
    padding: 1rem;
    border-radius: 0.75rem;
    font-size: 0.85rem;
    text-align: center;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    animation: fadeIn 0.3s ease-out;
  }

  .status.error {
    color: #ff4444;
    background: rgba(255, 68, 68, 0.05);
    border-color: rgba(255, 68, 68, 0.2);
  }

  .status.success {
    color: #00c851;
    background: rgba(0, 200, 81, 0.05);
    border-color: rgba(0, 200, 81, 0.2);
  }

  @keyframes fadeIn {
    from {
      opacity: 0;
      transform: translateY(5px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
</style>
