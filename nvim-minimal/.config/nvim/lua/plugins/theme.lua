-- lua/plugins/rose-pine.lua
return {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        vim.cmd("colorscheme rose-pine")
        -- Make Visual-mode selection stand out more than rose-pine's default
        vim.api.nvim_set_hl(0, "Visual", { bg = "#524f67", bold = true })
    end
}
