-- ~/.config/nvim/lua/custom/vscode_keymaps.lua
-- Updated to remove duplicates with shared config

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- NOTE: Leader keys, clipboard ops, indenting, and line movement are now in shared config

-- VSCode-specific keymaps
keymap("i", "<Tab>", "<Tab>", { noremap = false, silent = true })

-- removes highlighting after escaping vim search (keeping this VSCode-specific version)
keymap("n", "<Esc>", "<Esc>:noh<CR>", opts)

-- VSCode command mappings
keymap({"n", "v"}, "<leader>t", "<cmd>lua require('vscode').call('workbench.action.terminal.toggleTerminal')<CR>")
keymap({"n", "v"}, "<leader>bd", "<cmd>lua require('vscode').call('editor.debug.action.toggleBreakpoint')<CR>")
keymap({"n", "v"}, "<leader>d", "<cmd>lua require('vscode').call('editor.action.showHover')<CR>")
keymap({"n", "v"}, "<leader>ca", "<cmd>lua require('vscode').call('editor.action.quickFix')<CR>")
keymap({"n", "v"}, "<leader>sp", "<cmd>lua require('vscode').call('workbench.actions.view.problems')<CR>")
keymap({"n", "v"}, "<leader>cn", "<cmd>lua require('vscode').call('notifications.clearAll')<CR>")
keymap({"n", "v"}, "<leader>ff", "<cmd>lua require('vscode').call('workbench.action.quickOpen')<CR>")
keymap({"n", "v"}, "<leader>cp", "<cmd>lua require('vscode').call('workbench.action.showCommands')<CR>")
keymap({"n", "v"}, "<leader>pr", "<cmd>lua require('vscode').call('code-runner.run')<CR>")
keymap({"n", "v"}, "<leader>f", "<cmd>lua require('vscode').call('editor.action.formatDocument')<CR>")

-- File explorer (map to match your native config)
keymap({"n", "v"}, "<leader>ee", "<cmd>lua require('vscode').call('workbench.view.explorer')<CR>")

-- Search (map to match your native telescope keybindings)
keymap({"n", "v"}, "<leader>sf", "<cmd>lua require('vscode').call('workbench.action.quickOpen')<CR>")
keymap({"n", "v"}, "<leader>sg", "<cmd>lua require('vscode').call('workbench.action.findInFiles')<CR>")

-- Navigation (use VSCode's superior implementations)
keymap('n', 'gd', "<cmd>lua require('vscode').call('editor.action.revealDefinition')<CR>")
keymap('n', 'gr', "<cmd>lua require('vscode').call('editor.action.goToReferences')<CR>")
keymap('n', 'K', "<cmd>lua require('vscode').call('editor.action.showHover')<CR>")

-- harpoon keymaps
keymap({"n", "v"}, "<leader>ha", "<cmd>lua require('vscode').call('vscode-harpoon.addEditor')<CR>")
keymap({"n", "v"}, "<leader>ho", "<cmd>lua require('vscode').call('vscode-harpoon.editorQuickPick')<CR>")
keymap({"n", "v"}, "<leader>he", "<cmd>lua require('vscode').call('vscode-harpoon.editEditors')<CR>")
keymap({"n", "v"}, "<leader>h1", "<cmd>lua require('vscode').call('vscode-harpoon.gotoEditor1')<CR>")
keymap({"n", "v"}, "<leader>h2", "<cmd>lua require('vscode').call('vscode-harpoon.gotoEditor2')<CR>")
keymap({"n", "v"}, "<leader>h3", "<cmd>lua require('vscode').call('vscode-harpoon.gotoEditor3')<CR>")
keymap({"n", "v"}, "<leader>h4", "<cmd>lua require('vscode').call('vscode-harpoon.gotoEditor4')<CR>")
keymap({"n", "v"}, "<leader>h5", "<cmd>lua require('vscode').call('vscode-harpoon.gotoEditor5')<CR>")
keymap({"n", "v"}, "<leader>h6", "<cmd>lua require('vscode').call('vscode-harpoon.gotoEditor6')<CR>")
keymap({"n", "v"}, "<leader>h7", "<cmd>lua require('vscode').call('vscode-harpoon.gotoEditor7')<CR>")
keymap({"n", "v"}, "<leader>h8", "<cmd>lua require('vscode').call('vscode-harpoon.gotoEditor8')<CR>")
keymap({"n", "v"}, "<leader>h9", "<cmd>lua require('vscode').call('vscode-harpoon.gotoEditor9')<CR>")

-- project manager keymaps
keymap({"n", "v"}, "<leader>pa", "<cmd>lua require('vscode').call('projectManager.saveProject')<CR>")
keymap({"n", "v"}, "<leader>po", "<cmd>lua require('vscode').call('projectManager.listProjectsNewWindow')<CR>")
keymap({"n", "v"}, "<leader>pe", "<cmd>lua require('vscode').call('projectManager.editProjects')<CR>")
