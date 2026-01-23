require("config.lazy")
require("settings")
-- plugins are install @ .local/share/nvim/lazy


vim.cmd("colorscheme monokai-pro-spectrum")

-- Match .tq files to the torque language. It is important
-- to add torque.vim into .config/nvim/syntax/ for this to
-- work. File can be found in the v8 project at
-- v8/tools/torque/vim-torque/syntax/torque.vim
vim.filetype.add({
	extension = {
		tq = "torque",
		gn = "gn",
		gni = "gn",
	},
})

-- local gitlens = require("pack.gitblame.lua")
-- gitlens.setup({
--  show_time = 10000,
--  auto_show = true,
--  auto_show_delay = 10
-- })
-- gitlens.toggle_auto_show()
