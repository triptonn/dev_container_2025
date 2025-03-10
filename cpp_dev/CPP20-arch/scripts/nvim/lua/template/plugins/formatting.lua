return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		local format_options = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 500,
		}

		local clang_format_config = {
			prepend_args = {
				"--style=file:/home/vscode/.clang-format",
				"--fallback-style=LLVM",
			},
		}

		conform.setup({
			formatters_by_ft = {
				c = { "clang_format" },
				cpp = { "clang_format" },
				lua = { "stylua" },
				python = { "isort", "black" },
			},
			formatters = {
				black = {},
				clang_format = clang_format_config,
				isort = {},
				stylua = {},
			},
			format_on_save = format_options,
		})
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format(format_options)
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
