return {
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree" },
    },
    init = function()
      vim.g.undotree_WindowLayout = 4
    end,
  },
}
