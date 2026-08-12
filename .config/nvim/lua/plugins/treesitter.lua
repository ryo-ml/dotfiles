return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  -- Specify the main module to fix the "not found" error
  main = "nvim-treesitter",
  opts = {
    ensure_installed = {
      -- Core/Neovim
      "lua",
      "vim",
      "vimdoc",
      "query",

      -- Web Development
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",

      -- Programming Languages
      "python",
      "rust",
      "go",
      "cpp",
      "c",
      "ruby",

      -- Configuration & Data
      "json",
      "yaml",
      "toml",
      "bash",

      -- Documentation
      "markdown",
      "markdown_inline",
    },

    -- Enable syntax highlighting
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    -- Enable indentation based on treesitter
    indent = { enable = true },

    -- Automatically install missing parsers when entering buffer
    auto_install = true,
  },
}
