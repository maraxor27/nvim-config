return {
  "loctvl842/monokai-pro.nvim",
  lazy=false,
  priority=999,
  config=function()
    require("monokai-pro").setup();
    -- vim.cmd("colorscheme monokai-spectrum")
  end
}
