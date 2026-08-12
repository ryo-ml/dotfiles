return {
  -- Mason: Portable package manager for LSP servers and tools
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
      },
    },
  },

  -- Mason-lspconfig: Automatic installation bridge
  {
    "williamboman/mason-lspconfig.nvim",
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
  },

  -- nvim-lspconfig: Modern Neovim 0.11+ configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Configure Lua server with Neovim globals
      vim.lsp.enable("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- List of language servers to enable
      local servers = { 
        "pyright", 
        "rust_analyzer", 
        "clangd", 
        "ts_ls", 
        "html", 
        "cssls", 
        "yamlls", 
        "taplo" 
      }
      
      -- Enable servers using protected call to avoid errors if binary is missing
      for _, server in ipairs(servers) do
        pcall(vim.lsp.enable, server)
      end
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
