vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment / decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management (nvim)
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- tab management (nvim)
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- add empty line
keymap.set("n", "zk", "m`o<Esc>``", { desc = "Add empty line above cursor" })
keymap.set("n", "zj", "m`O<Esc>``", { desc = "Add empty line below cursor" })

-- dap
keymap.set("n", "<F5>", "<cmd>DapContinue<CR>", { desc = "Start debugging" })
keymap.set("n", "<F7>", "<cmd>DapTerminate<CR>", { desc = "Terminate debugging"})
keymap.set("n", "<F9>", "<cmd>DapStepBack<CR>", { desc = "Step back" })
keymap.set("n", "<F10>", "<cmd>DapStepInto<CR>", { desc = "Step into" })
keymap.set("n", "<F11>", "<cmd>DapStepOver<CR>", { desc = "Step over" })
keymap.set("n", "<F12>", "<cmd>DapStepOut<CR>", { desc = "Step out" })

keymap.set("n", "<leader>bb", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
keymap.set("n", "<leader>bB", "<cmd>:lua require('dap').set_breakpoint()<CR>", { desc = "Set breakpoint" })
keymap.set("n", "<leader>bM", "<cmd>:lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", { desc = "Set breakpoint (with message)" })
keymap.set("n", "<leader>bl", "<cmd>:lua require('dap').list_breakpoints()<CR>", { desc = "List breakpoints" })
keymap.set("n", "<leader>bC", "<cmd>DapClearBreakpoints<CR>", { desc = "Clear all breakpoints" })

keymap.set({"n", "v"}, "<leader>ih", "<cmd>:lua require('dap.ui.widgets').hover()<CR>", { desc = "DAP: Hover info" })
keymap.set("n", "<leader>if", "<cmd>:lua local widgets = require('dap.ui.widgets').centered_float(widgets.frames)<CR>", { desc = "DAP: Frames" })
keymap.set("n", "<leader>is", "<cmd>:lua local widgets = require('dap.ui.widgets').sidebar(widgets.scopes)<CR>", { desc = "DAP: Scopes" })
keymap.set("n", "<leader>iS", "<cmd>:lua local widgets = require('dap.ui.widgets').centered_float(widgets.sessions)<CR>", { desc = "DAP: Sessions" })
keymap.set("n", "<leader>ie", "<cmd>:lua local widgets = require('dap.ui.widgets').centered_float(widgets.expressions)<CR>", { desc = "DAP: Expressions" })
keymap.set("n", "<leader>it", "<cmd>:lua local widgets = require('dap.ui.widgets').centered_float(widgets.threads)<CR>", { desc = "DAP: Threads" })
