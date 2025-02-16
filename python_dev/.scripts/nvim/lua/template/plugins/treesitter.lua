return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({
			highlight = {
				enable = true,
			},

			-- enable indentation
			indent = { enable = true },

			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = { enable = true },

			-- ensure these language parsers are installed
			ensure_installed = {
				"c",
				"cpp",
				"dart",
				"python",
				"bash",
				"cmake",
				"comment",
				"css",
				"dockerfile",
				"gitignore",
				"html",
				"json",
				"lua",
				"ninja",
				"rasi",
				"regex",
				"rst",
				"sql",
				"toml",
				"vim",
				"xml",
				"yaml",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
