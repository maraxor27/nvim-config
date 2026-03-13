return {
  'maraxor27/nvim-gitblame',
  enabled = true,
  config = function()
    require("gitblame").setup({})
  end
}
