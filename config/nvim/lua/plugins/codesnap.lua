--code snapshot plugin
if true then
  return {}
end

return {
  "mistricky/codesnap.nvim",
  build = "make",
  config = function()
    require("codesnap").setup({
      watermark = "",
    })
  end,
}
