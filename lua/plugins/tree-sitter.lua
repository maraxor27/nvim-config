return {
	"nvim-treesitter/nvim-treesitter",
	enabled = true,
	tag = "v0.10.0",
	version = false, -- last release is way too old and doesn't work on Windows	
	lazy = false, -- load treesitter early when opening a file from the cmdline
	build = ":TSUpdate",
	cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
	opts_extend = { "ensure_installed" },
	---@class lazyvim.TSConfig: TSConfig
	opts = {
		-- LazyVim config for treesitter
		indent = { enable = true },
		highlight = { enable = true },
		folds = { enable = false },
		ensure_installed = {
			"bash",
			"c",
      "cpp",
			"diff",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		},
	},
	---@param opts lazyvim.TSConfig
	config = function(_, opts)
		local TS = require("nvim-treesitter")

		-- setup treesitter
		TS.setup(opts)
	end,
}
