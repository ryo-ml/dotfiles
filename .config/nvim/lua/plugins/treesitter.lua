-- nvim-treesitter `main` branch: it only installs parsers/queries. Highlighting
-- and indentation are enabled per buffer below (not via setup options).
local parsers = {
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
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    -- Compiling parsers needs the tree-sitter CLI; skip quietly where it's
    -- missing (e.g. servers) — Neovim's bundled parsers still work.
    if vim.fn.executable("tree-sitter") == 1 then
      require("nvim-treesitter").install(parsers) -- async, no-op if installed
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
      callback = function(args)
        -- Fails (quietly) when no parser exists for this filetype
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and vim.treesitter.query.get(lang, "indents") then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
