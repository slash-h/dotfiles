return {
  'nvim-telescope/telescope.nvim',
  tag = 'v0.2.0',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
      build = 'make'
    },
  },
  opts = {},
  config = function()
    -- require('telescope').setup({
    --   pickers = {
    --     find_files = {
    --       -- include hidden files but ignore files in .git directories
    --       find_command = {
    --         'rg',
    --         '--files',
    --         '--hidden',
    --         '-g',
    --         '!.git',
    --       },
    --     },
    --   },
    -- })
    local builtin = require('telescope.builtin')
    vim.keymap.set("n", "<space>fo", builtin.oldfiles)
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>ps', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end)
    vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    -- find files in neovim config directory (from anywhere)
    vim.keymap.set("n", "<space>en",
        function() builtin.find_files { cwd = vim.fn.stdpath("config") } 
    end)
    vim.keymap.set("n", "<space>fh", builtin.help_tags)
end,
}
