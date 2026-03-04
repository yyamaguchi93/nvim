-- ~/.config/nvim/init.lua
-- Keep your existing configuration structure and just add shared parts

-- Load shared configuration first (only basic settings that don't depend on plugins)
require('config.shared')
-- Set leader keys (works in both)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic search settings (works in both)
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Shared keymaps that work in both
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better indenting (works in both)
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move text up and down (works in both)
keymap('v', 'J', ":m '>+1<CR>gv=gv", opts)
keymap('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- System clipboard operations (works in both)
keymap({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
keymap({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })


keymap("v", "p", '"_dP', opts)

-- Boolean flip function (your custom function - works in both)
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

-- if vim.g.vscode then
--   -- VSCode Neovim
--   require "config.vscode"
--
-- else
-- Ordinary Neovim - Your existing config with minimal changes

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.cmd 'let g:netrw_liststyle = 3'

vim.filetype.add {
  extension = {
    zsh = 'zsh',
    sh = 'sh',
  },
  filename = {
    ['.zshrc'] = 'zsh',
    ['.zshenv'] = 'zsh',
  },
}

-- [[ Setting options ]]
vim.env.IN_NEOVIM = '1'

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim (moved to shared, but keeping fallback)
vim.opt.clipboard = 'unnamedplus'

vim.opt.shellcmdflag = '-ic'
-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.undoreload = 10000

-- Ensure undo directory exists
local undodir = vim.fn.stdpath 'state' .. '/undo'
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p')
end

-- Case-insensitive searching (moved to shared, keeping for safety)
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Tabs & indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- [[ Basic Keymaps ]]
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>a', '<C-^>', { desc = '[A]lternate file' })

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('v', '<leader>F', vim.lsp.buf.format, { desc = 'Format selection' })


-- Function to find and replace across all files in current directory
local function search_and_replace()
  local old = vim.fn.input('Replace: ')
  if old == '' then return end
  local new = vim.fn.input('With: ')
  if new == '' then return end
  
  -- Use ripgrep to find files and populate quickfix
  vim.cmd('grep! -r "' .. old .. '" .')
  
  -- Check if quickfix list is empty
  if #vim.fn.getqflist() == 0 then
    print('No matches found for: ' .. old)
    return
  end
  
  -- Replace in all files in quickfix list
  -- 'e' flag suppresses errors when pattern not found in a file
  vim.cmd('cfdo %s/' .. vim.fn.escape(old, '/\\') .. '/' .. vim.fn.escape(new, '/\\') .. '/gce | update')
end

-- Key mapping for search and replace
vim.keymap.set('n', '<leader>sR', search_and_replace, { desc = '[S]earch and [R]eplace in directory' })
-- [[ Basic Autocommands ]]
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = { '*' },
  callback = function()
    -- Restore last cursor position and open folds (equivalent to the previous nvim_exec call)
    vim.cmd('silent! normal! g`"zv')
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup {
  -- Import custom plugins into lazy.nvim setup
  -- Temporarily disable git-conflict.nvim due to a decoration-provider crash
  -- (Invalid 'line': out of range). Re-enable after upstream fix or
  -- replace with a patched version. See plugin: akinsho/git-conflict.nvim
  { 'akinsho/git-conflict.nvim', version = '*', enabled = false },
  'tpope/vim-sleuth',
  'tpope/vim-fugitive',

  { 'numToStr/Comment.nvim',     opts = {} },

  { -- Gitsigns
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Which-key
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk' },
        { '<leader>h', desc = 'Git [H]unk',  mode = 'v' },
      }
    end,
  },

  { -- Telescope
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = function()
        return vim.fn
            .executable 'make' == 1
      end },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            'vendor/.*', 'node_modules/.*', '%.git/.*', '%.DS_Store',
            'target/.*', 'build/.*', 'dist/.*', '%.lock',
            '%.venv/.*', -- Python virtual environment
          },
        },
        pickers = {
          find_files = {
            -- Use ripgrep to respect .gitignore
            find_command = { 'rg', '--files', '--hidden', '--glob', '!.git' },
          },
        },
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim',       opts = {} },
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local caps = client and client.server_capabilities or {}

          -- Jump to the definition of the word under your cursor.
          --  To jump back, press <C-t>.
          --  Falls back to Vim's built-in gd (local declaration) when LSP lacks support.
          if caps.definitionProvider then
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          else
            map('gd', function()
              -- Fallback: Telescope grep for word under cursor (cross-file local-declaration search)
              require('telescope.builtin').grep_string { word_match = '-w' }
            end, '[G]oto [D]efinition (grep fallback)')
          end

          -- Find references for the word under your cursor.
          if caps.referencesProvider then
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          else
            map('gr', function()
              require('telescope.builtin').grep_string { word_match = '-w' }
            end, '[G]oto [R]eferences (grep fallback)')
          end

          -- Jump to the implementation of the word under your cursor.
          if caps.implementationProvider then
            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          else
            map('gI', function()
              require('telescope.builtin').grep_string { word_match = '-w' }
            end, '[G]oto [I]mplementation (grep fallback)')
          end

          -- Jump to the type of the word under your cursor.
          if caps.typeDefinitionProvider then
            map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          else
            map('<leader>D', function()
              require('telescope.builtin').grep_string { word_match = '-w' }
            end, 'Type [D]efinition (grep fallback)')
          end

          -- Fuzzy find all the symbols in your current document.
          if caps.documentSymbolProvider then
            map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          end

          -- Fuzzy find all the symbols in your current workspace.
          if caps.workspaceSymbolProvider then
            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          end

          -- Rename the variable under your cursor.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          if client and client.name == 'clangd' then
            map('<leader>o', vim.cmd.ClangdSwitchSourceHeader, 'Switch Source/Header (C/C++)')
          end
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {
          keys = {
            { "<leader>o", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          }
        },
        bashls = {},
        jsonls = {},
        html = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = 'basic',
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        marksman = {},
        -- rust_analyzer = {},
        -- tsserver = {},

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'bash-language-server',
        'html-lsp',
        'jsonlint',
        'json-lsp',
        'prettier',
        'shellcheck',
        'markdownlint',
        'pyright',
        'gopls',
        'gofumpt',
        'marksman',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  { -- Autoformat
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      -- format_on_save = function(bufnr)
      --   -- Disable "format_on_save lsp_fallback" for languages that don't
      --   -- have a well standardized coding style. You can add additional
      --   -- languages here or re-enable it for the disabled ones.
      --   local disable_filetypes = { c = true, cpp = true, h = true, idl = true }
      --   return {
      --     timeout_ms = 500,
      --     lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      --   }
      -- end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Use the "*" filetype to run formatters on all filetypes.
        -- ['*'] = { 'codespell' },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ['_'] = { 'trim_whitespace' },
        bash = { 'shfmt' },
        sh = { 'shfmt' },
        python = { 'isort', 'black' },
        go = { 'gofumpt' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },

        -- Conform can also run multiple formatters sequentially
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
      },
    },
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          -- ['<CR>'] = cmp.mapping.confirm { select = true },
          -- ['<Tab>'] = cmp.mapping.select_next_item(),
          -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
  {
    'rmagatti/auto-session',
    config = function()
      local auto_session = require 'auto-session'

      auto_session.setup {
        log_level = 'error',
        -- auto_session_enable_last_session = true,
        -- auto_save_enabled = true,
        -- auto_restore_enabled = true,
        -- auto_session_use_git_branch = true,
      }

      -- local keymap = vim.keymap

      -- keymap.set('n', '<leader>wr', '<cmd>SessionRestore<CR>', { desc = 'Restore session for cwd' }) -- restore last workspace session for current directory
      -- keymap.set('n', '<leader>ws', '<cmd>SessionSave<CR>', { desc = 'Save session for auto session root dir' }) -- save workspace session for current working directory
    end,
  },

  {
    'oug-t/difi.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>df', ':Difi<CR>', desc = '[D]i[f]i toggle' },
    },
  },

  { import = 'plugins.themes' },
  { import = 'plugins.copilot' },
  { import = 'plugins.copilot-chat' },

  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙',
      keys = '🗝', plugin = '🔌', runtime = '💻', require = '🌙',
      source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
  },
}
-- end

-- ~/.config/nvim/lua/config/shared.lua
-- Only include settings that are safe and work in both environments
