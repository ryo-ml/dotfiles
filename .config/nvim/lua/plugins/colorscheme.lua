return {
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- Load during startup for immediate UI consistency
    priority = 1000, -- Ensure it loads before other plugins
    opts = {
      style = "storm", -- Options: "storm", "moon", "night", "day"
      transparent = false, -- Set to true for a transparent background
      terminal_colors = true, -- Configure colors for the built-in terminal
      styles = {
        -- Control font styles for different syntax elements
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
    },
    config = function(_, opts)
      local tokyonight = require("tokyonight")
      tokyonight.setup(opts)
      -- Apply the colorscheme
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
