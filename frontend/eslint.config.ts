import js from "@eslint/js";
import globals from "globals";
import tseslint from "typescript-eslint";
import svelte from "eslint-plugin-svelte";
import tsParser from "@typescript-eslint/parser";

export default [
  js.configs.recommended,
  ...tseslint.configs.recommended,
  ...svelte.configs["flat/recommended"],
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node,
      },
      parser: tsParser,
      parserOptions: {
        parser: "@typescript-eslint/parser",
        extraFileExtensions: [".svelte"],
      },
    },
  },
  {
    ignores: ["dist/**", "node_modules/**"],
  },
];
