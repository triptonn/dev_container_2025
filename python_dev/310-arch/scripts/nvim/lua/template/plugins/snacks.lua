return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = true,
	event = "VeryLazy",
	opts = {
		bigfile = { enabled = false },
		dashboard = { enabled = false },
		explorer = { enabled = false },
		indent = { enabled = false },
		input = { enabled = false },
		picker = { enabled = false },
		quickfile = { enabled = false },
		statuscolumn = { enabled = false },

		notifier = { enabled = true, timeout = 3000 },
		notify = { enabled = true },

		scope = {
			enabled = true,
			min_size = 2,
			debounce = 50,
			treesitter = {
				enabled = true,
				injection = false,
				blocks = {
					enabled = false,
				},
			},
		},
		words = {
			enabled = true,
			debounce = 500, -- time in ms to wait before updating
			notify_jump = false, -- show a notification when jumping
			notify_end = false, -- show a notification when reaching the end
			foldopen = false, -- open folds after jumping
			jumplist = true, -- set jump point before jumping
			modes = { "n" }, -- modes to show references n, i, ...
		},
	},
	keys = {
		-- words keymappings
		{
			"ö",
			function()
				require("snacks").words.jump(1, true)
			end,
			desc = "󰎟 Next reference",
		},
		{
			"Ö",
			function()
				require("snacks").words.jump(-1, true)
			end,
			desc = "󰉚 Prev reference",
		},
		{
			"<leader>hh",
			function()
				require("snacks").notifier.show_history()
			end,
			mode = { "n", "v", "i" },
			desc = "󰎟 Last notification",
		},
	},
}
