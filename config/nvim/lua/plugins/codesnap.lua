-- currently we don't want GO, so don't actually load anything here and return an empty spec
-- stylua: ignore
if true then return {} end

return {
  "mistricky/codesnap.nvim",
  build = "make",
  config = function()
    require("codesnap").setup({
      watermark = "",
    })
  end,
}
