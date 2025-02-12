return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	keys = {
		{ "<leader>xx", "<cmd>:Trouble diagnostics toggle<cr>", desc = "Open/Close trouble list" },
		{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Open trouble workspace diagnostics" },
		{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Open trouble document diagnostics" },
		{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Open trouble quickfix list" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Open trouble location list" },
		{ "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Open todos in trouble" },
	},
	event = "VeryLazy",
	cmd = { "TroubleToggle", "Trouble" },

	opts = {
		use_diagnostic_signs = true,
		action_keys = {
			close = { "q", "<esc>" },
			cancel = "<c-e>",
		},
	},
}
