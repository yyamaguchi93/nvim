-- ~/.config/nvim/lua/config/shared.lua
-- Configuration that works in both native Neovim and VSCode-Neovim

-- Set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Search settings that work in both
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Clipboard (works in both)
-- if vim.fn.has('macunix') == 1 then
  vim.opt.clipboard = 'unnamedplus'     -- macOS
-- else
  -- vim.opt.clipboard = 'unnamedplus' -- Linux
-- end
--

-- Shared keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Clear search highlights
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', opts)

-- Better indenting
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move text up and down
keymap('v', 'J', ":m '>+1<CR>gv=gv", opts)
keymap('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- System clipboard operations
keymap({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
keymap({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })

-- Boolean flip function (works in both environments)
local function flip_boolean()
  local word = vim.fn.expand('<cword>')
  local replacements = {
    ['true'] = 'false',
    ['false'] = 'true',
    ['True'] = 'False',
    ['False'] = 'True',
    ['TRUE'] = 'FALSE',
    ['FALSE'] = 'TRUE',
    ['yes'] = 'no',
    ['no'] = 'yes',
    ['Yes'] = 'No',
    ['No'] = 'Yes',
    ['YES'] = 'NO',
    ['NO'] = 'YES',
    ['on'] = 'off',
    ['off'] = 'on',
    ['On'] = 'Off',
    ['Off'] = 'On',
    ['ON'] = 'OFF',
    ['OFF'] = 'ON',
    ['0'] = '1',
    ['1'] = '0',
  }

  local replacement = replacements[word]
  if replacement then
    vim.cmd('normal! ciw' .. replacement)
  else
    print('No boolean flip found for: ' .. word)
  end
end

keymap('n', '<leader>b', flip_boolean, { desc = 'Flip boolean value under cursor' })

vim.g.root_spec = { "cwd" }
-- Method 3: Change directory when switching to files in different directories
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('AutoCDOnBufferChange', { clear = true }),
  desc = 'Auto change directory when switching buffers',
  callback = function()
    local file = vim.fn.expand('%:p')

    -- Skip special buffers, empty files, and non-file buffers
    if file == '' or vim.bo.buftype ~= '' or vim.bo.filetype == 'netrw' then
      return
    end

    -- Skip if file doesn't exist
    if vim.fn.filereadable(file) == 0 then
      return
    end

    local file_dir = vim.fn.fnamemodify(file, ':p:h')
    local current_dir = vim.fn.getcwd()

    if file_dir ~= current_dir then
      vim.cmd('cd ' .. vim.fn.fnameescape(file_dir))
      print('📁 ' .. vim.fn.fnamemodify(file_dir, ':t')) -- Show just the directory name
    end
  end,
})
