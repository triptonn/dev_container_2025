return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			python = { "pylint" },
			cmake = { "cmakelint" },
			cpp = { "cpplint" },
			json = { "jsonlint" },
			lua = { "luacheck" },
		}

		lint.linters.luacheck = {
			cmd = "luacheck",
			stdin = true,
			args = {
				"--globals",
				"vim",
				"lvim",
				"reload",
				"--",
			},
			stream = "stdout",
			ignore_exitcode = true,
			parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
				source = "luacheck",
			}),
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
