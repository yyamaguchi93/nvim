return {
  'CopilotC-Nvim/CopilotChat.nvim',
  branch = 'canary',
  dependencies = {
    { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
    { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
  },
  build = 'make tiktoken', -- Only on MacOS or Linux
  opts = {
    debug = false, -- Enable debugging
    -- See Configuration section for rest
  },
  config = function()
    require('CopilotChat').setup {
      debug = false, -- Enable debug logging
      proxy = nil, -- [protocol://]host[:port] Use this proxy
      allow_insecure = false, -- Allow insecure server connections

      model = 'gpt-4', -- GPT model to use, 'gpt-3.5-turbo' or 'gpt-4'
      temperature = 0.1, -- GPT temperature

      question_header = '## User ', -- Header to use for user questions
      answer_header = '## Copilot ', -- Header to use for AI answers
      error_header = '## Error ', -- Header to use for errors
      separator = '───', -- Separator to use in chat

      show_folds = true, -- Shows folds for sections in chat
      show_help = true, -- Shows help message as virtual lines when waiting for user input
      auto_follow_cursor = true, -- Auto-follow cursor in chat
      auto_insert_mode = false, -- Automatically enter insert mode when opening window and if auto follow cursor is enabled on new prompt
      clear_chat_on_new_prompt = false, -- Clears chat on every new prompt

      context = nil, -- Default context to use, 'buffers', 'buffer' or none (can be specified manually in prompt via @).
      history_path = vim.fn.stdpath 'data' .. '/copilotchat_history', -- Default path to stored history
      callback = nil, -- Callback to use when ask response is received

      -- default selection (visual or line)
      selection = function(source)
        local select = require 'CopilotChat.select'
        return select.visual(source) or select.line(source)
      end,

      -- default prompts
      prompts = {
        Explain = {
          prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.',
        },
        Review = {
          prompt = '/COPILOT_REVIEW Review the selected code.',
          callback = function(response, source)
            -- see config.lua for implementation
          end,
        },
        Fix = {
          prompt = '/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.',
        },
        Optimize = {
          prompt = '/COPILOT_GENERATE Optimize the selected code to improve performance and readablilty.',
        },
        Docs = {
          prompt = '/COPILOT_GENERATE Please add documentation comment for the selection.',
        },
        Tests = {
          prompt = '/COPILOT_GENERATE Please generate tests for my code.',
        },
        FixDiagnostic = {
          prompt = 'Please assist with the following diagnostic issue in file:',
          selection = require('CopilotChat.select').diagnostics,
        },
        Commit = {
          prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
          selection = require('CopilotChat.select').gitdiff,
        },
        CommitStaged = {
          prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
          selection = function(source)
            return require('CopilotChat.select').gitdiff(source, true)
          end,
        },
      },

      -- default window options
      window = {
        layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
        height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
        -- Options below only apply to floating windows
        relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
        border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = 'Copilot Chat', -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },

      -- default mappings
      mappings = {
        complete = {
          detail = 'Use @<Tab> or /<Tab> for options.',
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>',
        },
        reset = {
          normal = '<C-l>',
          insert = '<C-l>',
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-s>',
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>',
        },
        yank_diff = {
          normal = 'gy',
        },
        show_diff = {
          normal = 'gd',
        },
        show_system_prompt = {
          normal = 'gp',
        },
        show_user_selection = {
          normal = 'gs',
        },
      },
    }

    -- Keymaps for CopilotChat
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Open chat window
    keymap('n', '<leader>cc', '<cmd>CopilotChatToggle<cr>', { desc = '[C]opilot [C]hat toggle' })

    -- Quick chat with prompt
    keymap('n', '<leader>cq', function()
      local input = vim.fn.input 'Quick Chat: '
      if input ~= '' then
        require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
      end
    end, { desc = '[C]opilot [Q]uick chat' })

    -- Explain code
    keymap({ 'n', 'v' }, '<leader>ce', '<cmd>CopilotChatExplain<cr>', { desc = '[C]opilot [E]xplain' })

    -- Review code
    keymap({ 'n', 'v' }, '<leader>cr', '<cmd>CopilotChatReview<cr>', { desc = '[C]opilot [R]eview' })

    -- Fix code
    keymap({ 'n', 'v' }, '<leader>cf', '<cmd>CopilotChatFix<cr>', { desc = '[C]opilot [F]ix' })

    -- Optimize code
    keymap({ 'n', 'v' }, '<leader>co', '<cmd>CopilotChatOptimize<cr>', { desc = '[C]opilot [O]ptimize' })

    -- Generate docs
    keymap({ 'n', 'v' }, '<leader>cd', '<cmd>CopilotChatDocs<cr>', { desc = '[C]opilot [D]ocs' })

    -- Generate tests
    keymap({ 'n', 'v' }, '<leader>ct', '<cmd>CopilotChatTests<cr>', { desc = '[C]opilot [T]ests' })

    -- Fix diagnostic
    keymap('n', '<leader>cD', '<cmd>CopilotChatFixDiagnostic<cr>', { desc = '[C]opilot Fix [D]iagnostic' })

    -- Commit messages
    keymap('n', '<leader>cm', '<cmd>CopilotChatCommit<cr>', { desc = '[C]opilot Commit [M]essage' })
    keymap('n', '<leader>cM', '<cmd>CopilotChatCommitStaged<cr>', { desc = '[C]opilot Commit [M]essage (staged)' })

    -- Visual mode: Inline chat
    keymap('v', '<leader>ci', ':CopilotChatInPlace<cr>', { desc = '[C]opilot [I]nline chat' })

    -- Show help
    keymap('n', '<leader>ch', function()
      local actions = require 'CopilotChat.actions'
      require('CopilotChat.integrations.telescope').pick(actions.help_actions())
    end, { desc = '[C]opilot [H]elp actions' })

    -- Show prompt actions with telescope
    keymap({ 'n', 'v' }, '<leader>cp', function()
      local actions = require 'CopilotChat.actions'
      require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
    end, { desc = '[C]opilot [P]rompt actions' })
  end,
  event = 'VeryLazy',
}
