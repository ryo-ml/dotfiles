-- lua/config/options.lua

-- Clipboard synchronization
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- Appearance and Display
vim.opt.cursorline = true -- Highlight the current line
vim.opt.cursorlineopt = "number" -- Highlight only the line number
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = false -- Do not use relative line numbers
vim.opt.termguicolors = true -- Enable 24-bit RGB colors

-- Indentation and Tabs
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.tabstop = 4 -- Number of spaces tabs count for

-- Search
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override 'ignorecase' if search has capitals
vim.opt.wrapscan = true -- Search wraps around the end of the file

-- Behavior
vim.opt.mouse = "a" -- Enable mouse support for all modes
