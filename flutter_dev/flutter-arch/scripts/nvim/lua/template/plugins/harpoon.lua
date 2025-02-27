return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		vim.keymap.set("n", "<leader>v", function()
			harpoon:list():add()
		end, { desc = "Add file to harpoon" })

		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle harpoon quick menu" })

		vim.keymap.set("n", "<A-1>", function()
			harpoon:list():select(1)
		end, { desc = "1st harpoon file" })

		vim.keymap.set("n", "<A-2>", function()
			harpoon:list():select(2)
		end, { desc = "2nd harpoon file" })

		vim.keymap.set("n", "<A-3>", function()
			harpoon:list():select(3)
		end, { desc = "3rd harpoon file" })

		vim.keymap.set("n", "<A-4>", function()
			harpoon:list():select(4)
		end, { desc = "4th harpoon file" })

		vim.keymap.set("n", "<C-A-h>", function()
			harpoon:list():prev()
		end, { desc = "Prev harpoon buffer" })

		vim.keymap.set("n", "<C-A-l>", function()
			harpoon:list():next()
		end, { desc = "Next harpoon buffer" })
	end,
}
