-- lua/plugins/rose-pine.lua
-- return {
-- 	"rose-pine/neovim",
-- 	name = "rose-pine",
-- 	config = function()
-- 		vim.cmd("colorscheme rose-pine")
-- 	end
-- }

return {
    'junegunn/seoul256.vim',
    priority = 1000,
    init = function()
      -- dark: 233 (darkest) ~ 239 (lightest), light: 252 (darkest) ~ 256 (lightest)
      vim.g.seoul256_background = 233
      vim.g.seoul256_light_background = 252
      vim.cmd.colorscheme 'seoul256-light'
      vim.cmd.hi 'Comment gui=none'
      -- Dark cursor for visibility on light background
      vim.cmd.hi 'Cursor guifg=#d9d7d5 guibg=#424242'
      vim.cmd.hi 'CursorLine guibg=#cccac8'
    end
  }
