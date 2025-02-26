return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({
			sync_install = false,
			auto_install = false,

			-- performance optimisation
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_reges_highlighting = false,
			},

			ignore_install = {},
			modules = {},

			-- enable indentation, diasable for languages where treesitter indent might be an issue
			indent = { enable = true, disable = { "python", "yaml" } },

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<C-s>",
					node_decremental = "<bs>",
				},
			},

			-- Add textobjects for better code navigation
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
			},

			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = { enable = true },

			-- ensure these language parsers are installed
			ensure_installed = {

				-- Core
				"vim",
				"lua",
				"regex",

				-- Web
				"html",
				"css",
				"javascript",
				"typescript",

				-- System
				"bash",
				"dockerfile",

				-- Programming
				"c",
				"cpp",
				"cmake",
				"ninja",
				"dart",
				"python",

				-- Data/Config
				"sql",
				"json",
				"yaml",
				"toml",
				"xml",

				-- Documentation
				"rst",
				"markdown",

				-- Other
				"comment",
				"gitignore",
			},
		})
		-- Set foldmethod to expr and use tresitter for folding
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt.foldenable = false -- Disable folding at startup
	end,
}
