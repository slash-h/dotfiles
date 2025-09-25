-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Custom Setup (uncomment below lines when nvim-treesitter is updated to 'main' branch.
-- The old code in plugins/treesitter.lua doesn't work after nvim-treesitter updated to main branch)

-- CDS LANGUAGE SUPPORT

vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").cds = {
      install_info = {
        url = "https://github.com/cap-js-community/tree-sitter-cds.git",
        -- revision = "HEAD",
        branch = "main",
      },
    }
  end,
})
--
-- LSP-based completion support
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})
-- Control LSP support by filetype
vim.lsp.enable({
  "javascript",
  "cds",
  -- 'lua',
})

-- LSP logging
vim.lsp.set_log_level("WARN")

-- DIAGNOSTICS

-- How diagnostics are displayed
vim.diagnostic.config({
  virtual_lines = { current_line = true },
  severity_sort = true,
})

-- GENERAL OPTIONS

-- vim.opt.list = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes:1"
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.winborder = "rounded"

-- FILETYPES

vim.filetype.add({ extension = { cds = "cds" } })
