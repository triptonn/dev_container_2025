return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = false },
		dashboard = { enabled = false },
		dim = { enabled = true },
		explorer = { enabled = false },
		indent = { enabled = false },
		input = { enabled = false },
		notifier = { enabled = true, timeout = 5000 },
		notify = { enabled = true },
		picker = { enabled = false },
		quickfile = { enabled = false },
		scope = {
			enabled = true,
			-- absolute minimum size of the scope.
			-- can be less if the scope is a top-level single line scope
			min_size = 2,
			-- try to expand the scope to this size
			max_size = nil,
			cursor = true, -- when true, the column of the cursor is used to determine the scope
			edge = true, -- include the edge of the scope (typically the line above and below with smaller indent)
			siblings = false, -- expand single line scopes with single line siblings
			-- what buffers to attach to
			filter = function(buf)
				return vim.bo[buf].buftype == ""
			end,
			-- debounce scope detection in ms
			debounce = 30,
			treesitter = {
				-- detect scope based on treesitter.
				-- falls back to indent based detection if not available
				enabled = true,
				injections = true, -- include language injections when detecting scope (useful for languages like `vue`)
				---@type string[]|{enabled?:boolean}
				blocks = {
					enabled = false, -- enable to use the following blocks
					"function_declaration",
					"function_definition",
					"method_declaration",
					"method_definition",
					"class_declaration",
					"class_definition",
					"do_statement",
					"while_statement",
					"repeat_statement",
					"if_statement",
					"for_statement",
				},
				-- these treesitter fields will be considered as blocks
				field_blocks = {
					"local_declaration",
				},
			},
			-- These keymaps will only be set if the `scope` plugin is enabled.
			-- Alternatively, you can set them manually in your config,
			-- using the `Snacks.scope.textobject` and `Snacks.scope.jump` functions.
			keys = {
				---@type table<string, snacks.scope.TextObject|{desc?:string}>
				textobject = {
					ii = {
						min_size = 2, -- minimum size of the scope
						edge = false, -- inner scope
						cursor = false,
						treesitter = { blocks = { enabled = false } },
						desc = "inner scope",
					},
					ai = {
						cursor = false,
						min_size = 2, -- minimum size of the scope
						treesitter = { blocks = { enabled = false } },
						desc = "full scope",
					},
				},
				---@type table<string, snacks.scope.Jump|{desc?:string}>
				jump = {
					["[i"] = {
						min_size = 1, -- allow single line scopes
						bottom = false,
						cursor = false,
						edge = true,
						treesitter = { blocks = { enabled = false } },
						desc = "jump to top edge of scope",
					},
					["]i"] = {
						min_size = 1, -- allow single line scopes
						bottom = true,
						cursor = false,
						edge = true,
						treesitter = { blocks = { enabled = false } },
						desc = "jump to bottom edge of scope",
					},
				},
			},
		},
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
			win = { style = "scratch", relative = "editor" },
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
		},
		scroll = { enabled = true },
		statuscolumn = { enabled = false },

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
			"<leader>hh",
			function()
				require("snacks").notifier.show_history()
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
