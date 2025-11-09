return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = '[[', -- Jump to previous suggestion in the panel
          jump_next = ']]', -- Jump to next suggestion in the panel
          accept = '<CR>', -- Accept the currently selected suggestion
          refresh = 'gr', -- Refresh/regenerate suggestions
          open = '<M-CR>', -- Open the Copilot panel (Alt + Enter)
        },
        layout = {
          position = 'bottom', -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = '<Tab>', -- Changed to Tab
          next = '<C-n>',
          prev = '<C-p>',
          dismiss = '<C-d>',
        },
      },
      filetypes = {
        -- yaml = true,
        -- markdown = true,
        -- text = true,
        -- gitcommit = true,
        -- gitrebase = false,
        -- help = false,
        -- hgcommit = false,
        -- svn = false,
        -- cvs = false,
        ['.'] = true,
      },
      copilot_node_command = 'node', -- Node.js version must be > 16.x
      server_opts_overrides = {},
    }
  end,
}
