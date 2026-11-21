return {
  -- Mason: Portable package manager for LSP servers and tools
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },

  -- Mason-lspconfig: installs the servers below and enables every installed
  -- server automatically (`automatic_enable`, on by default)
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig", -- default configs for each server
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "clangd",
        "ts_ls",
        "html",
        "cssls",
        "yamlls",
        "taplo",
      },
    },
    config = function(_, opts)
      -- Server settings must be registered before servers get enabled
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      require("mason-lspconfig").setup(opts)
    end,
  },

  -- nvim-cmp: Autocompletion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(), -- Manual trigger
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm selection
          ["<Tab>"] = cmp.mapping.select_next_item(), -- Navigate menu
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        -- Sources order defines priority
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- LSP results
          { name = "path" },     -- File system paths
        }, {
          { name = "buffer" },   -- Text within current buffer
        }),
      })
    end,
  },
}
