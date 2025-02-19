return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = false },
		dashboard = { enabled = false },
		explorer = { enabled = false },
		indent = { enabled = false },
		input = { enabled = false },
		notifier = { enabled = true },
		picker = { enabled = true },
		quickfile = { enabled = false },
		scope = { enabled = true },
		scratch = {
			-- enabled = true,
			name = "Scratch",
			ft = function()
				if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
					return vim.bo.filetype
				end
				return "markdown"
			end,
			icon = nil, -- `icon|{icon, icon_hl}`. defaults to the filetype icon
			root = vim.fn.stdpath("data") .. "/scratch",
			autowrite = true, -- automatically write when the buffer is hidden
			filekey = {
				cwd = true, -- use current working directory
				branch = true, -- use current branch name
				count = true, -- use vim.v.count1
			},
			win = { style = "scratch" },
			win_by_ft = {
				lua = {
					keys = {
						["source"] = {
							"<cr>",
							function(self)
								local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
								Snacks.debug.run({ buf = self.buf, name = name })
							end,
							desc = "Source buffer",
							mode = { "n", "x" },
						},
					},
				},
			},
			scope = { enabled = false },
			scroll = { enabled = true },
			statuscolumn = { enabled = false },
		},
		words = {
			-- enabled = true,
			debounce = 300, -- time in ms to wait before updating
			notify_jump = false, -- show a notification when jumping
			notify_end = true, -- show a notification when reaching the end
			foldopen = true, -- open folds after jumping
			jumplist = true, -- set jump point before jumping
			modes = { "n", "i", "c" }, -- modes to show references
		},
	},
	keys = {
		-- scratch keymappings
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},

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
			"<leader>g?",
			function()
				require("snacks").git.blame_line()
			end,
			desc = " Blame line",
		},
		{
			"<D-9>",
			function()
				openNotif("last")
			end,
			mode = { "n", "v", "i" },
			desc = "󰎟 Last notification",
		},
		{
			"<leader>om",
			function()
				local enabled = require("snacks").dim.enabled
				require("snacks").dim[enabled and "disable" or "enable"]()
			end,
			desc = "󰝟 Mute code",
		},
	},
}
