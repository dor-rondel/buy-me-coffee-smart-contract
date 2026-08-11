<script lang="ts">
  import { onMount } from "svelte";

  let visible = false;
  let dismissTimeout: ReturnType<typeof setTimeout>;

  function dismiss() {
    visible = false;
    clearTimeout(dismissTimeout);
  }

  onMount(() => {
    if (!window.ethereum) {
      visible = true;

      dismissTimeout = setTimeout(() => {
        visible = false;
      }, 5000);
    }

    return () => clearTimeout(dismissTimeout);
  });
</script>

{#if visible}
  <div class="alert-overlay" role="presentation" on:click={dismiss}>
    <div
      class="wallet-alert"
      role="alertdialog"
      aria-modal="true"
      aria-labelledby="wallet-alert-title"
      aria-describedby="wallet-alert-description"
      on:click|stopPropagation
    >
      <button
        class="close-button"
        type="button"
        aria-label="Dismiss wallet warning"
        on:click={dismiss}
      >
        ×
      </button>

      <div class="icon" aria-hidden="true">🦊</div>

      <div class="content">
        <h2 id="wallet-alert-title">Wallet Required</h2>

        <p id="wallet-alert-description">
          To use this dApp, you'll need a funded hot wallet extension active in
          your browser.
        </p>

        <p class="hint">
          Install or unlock a wallet such as MetaMask, then refresh the page.
        </p>
      </div>

      <div class="progress" aria-hidden="true"></div>
    </div>
  </div>
{/if}

<style>
  .alert-overlay {
    position: fixed;
    inset: 0;
    z-index: 1000;

    display: flex;
    align-items: flex-start;
    justify-content: center;

    padding: 1.5rem;
    padding-top: clamp(1.5rem, 8vh, 5rem);

    background: rgba(0, 0, 0, 0.45);
    backdrop-filter: blur(4px);
    -webkit-backdrop-filter: blur(4px);

    animation: fadeIn 0.2s ease-out;
  }

  .wallet-alert {
    position: relative;

    display: flex;
    gap: 1rem;
    width: min(100%, 480px);

    padding: 1.5rem;
    padding-right: 3.5rem;

    color: #fff;

    background:
      linear-gradient(rgba(25, 25, 25, 0.94), rgba(25, 25, 25, 0.94))
        padding-box,
      linear-gradient(to bottom right, #ff8c00, #ff4500) border-box;

    border: 2px solid transparent;
    border-radius: 1.25rem;

    box-shadow:
      0 20px 50px rgba(0, 0, 0, 0.55),
      0 0 30px rgba(255, 69, 0, 0.12);

    overflow: hidden;

    animation: slideDown 0.35s ease-out;
  }

  .icon {
    flex: 0 0 auto;

    display: grid;
    place-items: center;

    width: 3rem;
    height: 3rem;

    border-radius: 0.9rem;

    background: linear-gradient(
      135deg,
      rgba(255, 140, 0, 0.18),
      rgba(255, 69, 0, 0.18)
    );

    font-size: 1.5rem;
  }

  .content {
    min-width: 0;
  }

  h2 {
    margin: 0 0 0.5rem;

    font-size: 1.15rem;
    font-weight: 800;

    background: linear-gradient(45deg, #ff8c00, #ff4500);
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  p {
    margin: 0;

    font-size: 0.95rem;
    line-height: 1.5;
    color: #eee;
  }

  .hint {
    margin-top: 0.5rem;

    font-size: 0.8rem;
    color: #999;
  }

  .close-button {
    position: absolute;
    top: 0.75rem;
    right: 0.75rem;

    display: grid;
    place-items: center;

    width: 2rem;
    height: 2rem;

    padding: 0;

    border: 0;
    border-radius: 50%;

    background: rgba(255, 255, 255, 0.06);
    color: #aaa;

    font-size: 1.4rem;
    line-height: 1;

    cursor: pointer;

    transition:
      background 0.2s ease,
      color 0.2s ease,
      transform 0.2s ease;
  }

  .close-button:hover {
    background: rgba(255, 140, 0, 0.15);
    color: #fff;
    transform: scale(1.05);
  }

  .close-button:focus-visible {
    outline: 2px solid #ff8c00;
    outline-offset: 2px;
  }

  .progress {
    position: absolute;
    bottom: 0;
    left: 0;

    height: 3px;
    width: 100%;

    background: linear-gradient(90deg, #ff8c00, #ff4500);

    transform-origin: left;
    animation: countdown 5s linear forwards;
  }

  @keyframes countdown {
    from {
      transform: scaleX(1);
    }

    to {
      transform: scaleX(0);
    }
  }

  @keyframes fadeIn {
    from {
      opacity: 0;
    }

    to {
      opacity: 1;
    }
  }

  @keyframes slideDown {
    from {
      opacity: 0;
      transform: translateY(-15px) scale(0.98);
    }

    to {
      opacity: 1;
      transform: translateY(0) scale(1);
    }
  }

  @media (max-width: 480px) {
    .alert-overlay {
      align-items: flex-start;
      padding: 1rem;
      padding-top: 1rem;
    }

    .wallet-alert {
      gap: 0.75rem;

      padding: 1.25rem;
      padding-right: 3rem;

      border-radius: 1rem;
    }

    .icon {
      width: 2.5rem;
      height: 2.5rem;
      font-size: 1.25rem;
    }

    h2 {
      font-size: 1.05rem;
    }

    p {
      font-size: 0.9rem;
    }
  }

  @media (prefers-reduced-motion: reduce) {
    .alert-overlay,
    .wallet-alert,
    .progress {
      animation: none;
    }
  }
</style>
