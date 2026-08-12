return {
  -- autopairs: Integration for automatically closing brackets/quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")

      autopairs.setup({
        check_ts = true, -- Enable Treesitter integration
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
      })

      -- If you want to integrate with nvim-cmp (confirming with Enter also closes pairs)
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
