-- Use MasonInstall to install stuff

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.o.completeopt = "menu,menuone,noselect"
vim.g.mkdp_math = 1  -- Enable LaTeX math support in markdown preview

-- Initialize lazy.nvim
require('lazy').setup({
  -- Plugin manager
  'folke/lazy.nvim',

  -- Codeium plugin
  { 'Exafunction/codeium.vim' },

  { 'terrortylor/nvim-comment' },

  {
    'voldikss/vim-floaterm',
    lazy = false,        -- ensure Floaterm loads immediately
  },
  -- LazyGit integration
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      -- Load configuration from separate file
      require('lazygit_config').setup()
    end,
  },
  
  -- Floating Terminal
  {
    'voldikss/vim-floaterm',
    lazy = false,
    config = function()
      -- Load the custom floating terminal configuration
      require('float_term').setup({
        width = 0.85,
        height = 0.85,
        title = " Terminal ",
        border = "double"
      })
      
      -- Additional keymaps for floating terminal
      vim.api.nvim_set_keymap('n', '<F12>', ':lua require("float_term").toggle()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('t', '<F12>', '<C-\\><C-n>:lua require("float_term").toggle()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>ft', ':lua require("float_term").toggle()<CR>', { noremap = true, silent = true })
    end,
  },

  {
  'akinsho/flutter-tools.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    require("flutter-tools").setup({
      lsp = {
        on_attach = function(client, bufnr)
          -- You can add any custom on_attach logic here
        end,
        capabilities = capabilities,
      }
    })
  end,
},

  -- Themes
  { 'dracula/vim', as = 'dracula' },
  { 'ghifarit53/tokyonight-vim' },
  { 'navarasu/onedark.nvim' },
  { 'shaunsingh/nord.nvim' },
  { 'sainnhe/everforest' },
  { 
	  'scottmckendry/cyberdream.nvim',
	  priority=1000,
  },
  { 'nyoom-engineering/oxocarbon.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'marko-cerovac/material.nvim' },

  -- File tree explorer
  { 'preservim/nerdtree', cmd = 'NERDTreeToggle' },

  -- Adding custom snippets and boilerplates
  {
    "L3MON4D3/LuaSnip",
    -- Windows doesn't need the build step for LuaSnip
    dependencies = {
      "rafamadriz/friendly-snippets", -- this repo provides a ton of premade snippets
    },
    config = function()
      require("luasnip").config.setup {}
      -- Load snippets from friendly-snippets (and any others in your VSCode-style snippets dirs)
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },


  -- Autopairs for brackets
  { 'windwp/nvim-autopairs' },

  -- Smooth cursor animation
  {
  'echasnovski/mini.animate',
  lazy = false, -- Force loading
  config = function()
    require('mini.animate').setup({
      cursor = {
        enable = true,
        timing = require('mini.animate').gen_timing.linear({ duration = 150, unit = 'total' }),
        path = require('mini.animate').gen_path.line({
          predicate = function() return true end,
        }),
      },
      scroll = {
        enable = false,
        timing = require('mini.animate').gen_timing.linear({ duration = 150, unit = 'total' }),
      },
    })
  end,
},

  -- Easy Project navigation
{
  'ahmedkhalf/project.nvim',
  config = function()
    require("project_nvim").setup {
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Cargo.toml" },
      detection_methods = { "pattern" },
      show_hidden = false,
    }
    require('telescope').load_extension('projects')
    vim.api.nvim_set_keymap('n', '<leader>fp', ':Telescope projects<CR>', { noremap = true, silent = true })
  end,
},

  -- which-key
  { 'folke/which-key.nvim',

    event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  }, 
  },  -- FIXED: added missing comma

  -- Language support
  { 'vim-python/python-syntax' },
  { 'octol/vim-cpp-enhanced-highlight' },
  { 'ziglang/zig.vim' },
  { 'rust-lang/rust.vim', ft = { 'rust' } },

  -- Autocompletion
  -- { 'hrsh7th/nvim-cmp' },
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",  -- Lazy load when entering insert mode
    config = function()
        require("cmp").setup()
    end,
  },

  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'L3MON4D3/LuaSnip' },
  { 'rafamadriz/friendly-snippets' },

  -- Indent Guides - Visualize indentation levels
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end,
  },

  -- Smooth Scrolling
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup({
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = true,
    cursor_scrolls_alone = true,
  })
end,
},

-- Diagnostics - A pretty diagnostics list
{
'folke/trouble.nvim',
dependencies = 'kyazdani42/nvim-web-devicons',
config = function()
require('trouble').setup()
vim.api.nvim_set_keymap('n', '<leader>xx', '<cmd>TroubleToggle<CR>', { noremap = true, silent = true })
end,
},

-- Improved hot jump
{
'phaazon/hop.nvim',
config = function()
require('hop').setup()
vim.api.nvim_set_keymap('n', '<leader>hw', ':HopWord<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>hl', ':HopLine<CR>', { noremap = true, silent = true })
end,
},

-- Quick Fix
{
'kevinhwang91/nvim-bqf',
ft = 'qf',
config = function()
require('bqf').setup({
  auto_enable = true,
  preview = {
    win_height = 12,
    win_vheight = 12,
    delay_syntax = 80,
    border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
  },
})
end,
},

{
'kylechui/nvim-surround',
event = "VeryLazy",
config = function()
require("nvim-surround").setup()
end,
},



-- LSP Configurations
{ 'neovim/nvim-lspconfig' },
{ 'williamboman/mason.nvim' },
{ 'williamboman/mason-lspconfig.nvim' },


-- Rust analyzer (with lazy loading)
{
'simrat39/rust-tools.nvim',
ft = { 'rust' },  -- Lazy load only for Rust files
dependencies = {
  'neovim/nvim-lspconfig',
  'nvim-lua/plenary.nvim',
},
config = function()
  require('rust-tools').setup({
    server = {
      on_attach = function(client, bufnr)
        -- Enable keybindings only for Rust files
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
      end,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    },
  })
end,
},

-- Commenting (another plugin)
{ 'numToStr/Comment.nvim' },

-- Telescope and dependencies
{ 'nvim-telescope/telescope.nvim' },
{ 'nvim-lua/plenary.nvim' },

-- Treesitter for better syntax highlighting
{ 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

-- Additional UI improvements
{ 'kyazdani42/nvim-web-devicons' },

-- Status line
{ 'nvim-lualine/lualine.nvim' },

-- Note-taking and documentation features
{
"iamcco/markdown-preview.nvim",
build = "cd app && npm install",
ft = "markdown",
cmd = "MarkdownPreview",
config = function()
  vim.api.nvim_set_keymap("n", "<leader>mp", ":MarkdownPreview<CR>", { noremap = true, silent = true })
end,
},
--   {
--   "ellisonleao/glow.nvim",
--   config = function()
--     require("glow").setup({
--       -- Customize how you want the preview to appear; you can tweak the border and other settings here.
--       border = "rounded",
--     })
--   end,
--   cmd = "Glow",
-- }
{
"MeanderingProgrammer/render-markdown.nvim",
dependencies = {
"nvim-treesitter/nvim-treesitter",
"echasnovski/mini.nvim"  -- or use 'nvim-web-devicons' if you prefer
},
opts = {
-- You can customize things here; for instance:
enabled = true,
file_types = { "markdown" },
preset = "none",  -- start with no preset; adjust as desired
latex = {
  enabled = true,  -- ensure LaTeX blocks are rendered
  converter = "latex2text",  -- or whichever converter you use
},
heading = {
  position = "overlay",  -- display the heading icon over the concealed '#'
  icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
},
-- Other settings to fine-tune the floating window (you can adjust border, padding, etc.)
-- win_options = {
--   conceallevel = 3,
--   concealcursor = "",
-- },
-- win_options = {
--     concealcursor = { rendered = 'nvic' },
-- },
win_options = {
      conceallevel = {
      default  = 0,  -- for other mode rendering, if conceallevel >= 1, () doesn't show event insert mode
      rendered = 3,  -- for normal mode rendering
      },
      concealcursor = {  -- which mode to conceal cursorline
      default  = '',
      rendered = '', -- disable conceal at cursorline
      },
      },

code = {
        enabled          = true,
        sign             = false,                -- don't show icon of code block in sign column
          style            = 'full',               -- symbol + Lang
          left_pad         = 0,                    -- padding to left of code block
          right_pad        = 2,                    -- for 'block' width
          width            = 'block',
        border           = 'thick',              -- render full background region of code
          highlight        = 'RenderMarkdowncode', -- highlight of code block
          highlight_inline = '',                   -- disable highlight of inline code
      },

},
},

{
"sbdchd/neoformat",
cmd = "Neoformat",
config = function()
  -- Optional: Create a keybinding for markdown formatting
  vim.api.nvim_set_keymap("n", "<leader>mf", ":FloatermNew --height=0.9 --width=0.9 --wintype=float --name=lazygit --title=LazyGit --autoclose=2 lazygit<CR>", { noremap = true, silent = true })
  vim.cmd([[ autocmd BufWritePre *.md undojoin | Neoformat ]])
end,
},
{
"lervag/vimtex",
ft = "tex",
config = function()
  -- vimtex automatically sets up many useful keybindings for compiling LaTeX.
  -- For example, \ll starts the compilation, and \lv views the PDF.
  vim.g.vimtex_view_method = 'sumatrapdf'  -- SumatraPDF is a good PDF viewer for Windows
  vim.g.vimtex_compiler_method = 'latexmk'
end,
},
{
"akinsho/toggleterm.nvim",
config = function()
  require("toggleterm").setup{
    size = 20,
    open_mapping = [[<c-\\>]],
    shading_factor = 2,
    direction = "horizontal",
    float_opts = {
      border = "curved",
    },
  }
  -- Keybinding for toggling terminal
  vim.api.nvim_set_keymap("n", "<leader>tt", ":ToggleTerm<CR>", { noremap = true, silent = true })
end,
},

-- Autopairs (lazy loaded)
{
'windwp/nvim-autopairs',
event = 'InsertEnter',
config = function()
  require('nvim-autopairs').setup()
end,
},
})

-- Set up nvim-autopairs with extra config
require('nvim-autopairs').setup({
enable_check_bracket_line = true,
})

-- Cyberdream theme Configurations
-- require("cyberdream").setup({
--   transparent = true,
--   italic_comments = true,
--   borderless_pickers = true,
--   cache = false
-- })

-- Treesitter setup
require'nvim-treesitter.configs'.setup {
ensure_installed = { "lua", "python", "cpp", "javascript", "rust", "c", "asm", "kotlin", "dart", "go" },
highlight = {
enable = true,
additional_vim_regex_highlighting = false,
},
}


-- Lualine setup
require('lualine').setup {
options = {
theme = 'nord',  -- or another theme of your choice
section_separators = '',
component_separators = '',
}
}

-- which-key setup
require("which-key").setup {}

-- Leader Key
vim.g.mapleader = " " -- sets the leader key to spacebar

-- Basic settings
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.tabstop = 4
vim.o.tabstop = 4        -- Number of spaces that a <Tab> character represents
vim.o.shiftwidth = 4     -- Number of spaces to use for each step of (auto)indent
vim.o.expandtab = true   -- Use spaces instead of tabs
vim.opt.encoding = 'UTF-8'
vim.opt.autoindent = true
vim.opt.clipboard = 'unnamed'  -- Use system clipboard on Windows
vim.opt.undofile = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.wildmenu = true
vim.opt.wildmode = 'list:longest'
vim.opt.hidden = true
vim.opt.foldmethod = 'syntax'
vim.opt.foldlevelstart = 99
vim.opt.timeoutlen = 500
vim.opt.updatetime = 300
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'

-- Theme configuration
vim.g.tokyonight_style = 'night'
vim.g.tokyonight_enable_italic = true
vim.g.onedark_config = { style = 'darker' }

-- Comment.nvim configuration (using Ctrl+/)
require('nvim_comment').setup({
  -- Windows terminals often send <C-_> for Ctrl+/
  line_mapping = '<C-_>',
  operator_mapping = '<C-_>',
  comment_chunk_text_object = 'ic',
})

-- Add additional mapping for commenting that works in Windows
vim.api.nvim_set_keymap('n', '<C-_>', ':CommentToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-_>', ':CommentToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-_>', '<Esc>:CommentToggle<CR>a', { noremap = true, silent = true })

function _G.tab_complete()
local cmp = require("cmp")
local luasnip = require("luasnip")
if cmp.visible() then
return cmp.select_next_item()
elseif luasnip.expand_or_jumpable() then
return luasnip.expand_or_jump()
else
return "\t"  -- insert a literal tab
end
end

-- Require nvim-autopairs module
local npairs = require("nvim-autopairs")

local cmp = require'cmp'
cmp.setup({
window = {
completion = cmp.config.window.bordered(),  -- Optional
documentation = cmp.config.window.bordered(),  -- Optional
},
mapping = cmp.mapping.preset.insert({
['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
['<CR>'] = cmp.mapping.confirm({ select = true }),
}),
sources = cmp.config.sources({
{ name = 'nvim_lsp' },
{ name = 'buffer' },
{ name = 'path' },
}),
})

local cmp = require('cmp')
cmp.setup({
completion = {
completeopt = 'menu,menuone,noinsert',
},
snippet = {
expand = function(args)
  require('luasnip').lsp_expand(args.body)
end,
},
mapping = {
['<C-Space>'] = cmp.mapping.complete(),
['<C-y>'] = cmp.mapping.confirm({ select = true }),
['<C-e>'] = cmp.mapping.close(),
['<C-n>'] = cmp.mapping.select_next_item(),
['<C-p>'] = cmp.mapping.select_prev_item(),
['<CR>'] = cmp.mapping.confirm({ select = true }),
-- ['<Tab>'] = function(fallback)
--   if cmp.visible() then
--     cmp.select_next_item()
--   elseif npairs.check_insert_char() then
--     npairs.autopairs_insert()
--   else
--     fallback()
--   end
-- end,
['<S-Tab>'] = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif npairs.check_insert_char() then
    npairs.autopairs_insert()
  else
    fallback()
  end
end,
},
sources = {
{ name = 'nvim_lsp' },
{ name = 'luasnip' },
{ name = 'buffer' },
{ name = 'path' },
},
})

vim.api.nvim_create_user_command('MarkdownToPdf', function()
-- Get the current file's full path
local current_file = vim.fn.expand('%:p')
-- Prompt the user for the desired output PDF name
local output_name = vim.fn.input("Enter output PDF name (without extension): ")
if output_name == "" then
print("No output name provided. Aborting conversion.")
return
end
-- Construct the pandoc command. You can customize additional pandoc options here if needed.
local cmd = string.format("pandoc %s -o %s.pdf", current_file, output_name)
local result = os.execute(cmd)
if result == 0 then
print("Converted to " .. output_name .. ".pdf successfully!")
else
print("Conversion failed. Check that pandoc and a working LaTeX installation are available.")
end
end, { nargs = 0 })


vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevel = 99  -- so folds are open by default

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'pyright', 'clangd', 'zls', 'bashls', 'jdtls', 'gopls', 'kotlin_language_server', 'rust_analyzer', 'asm_lsp', 'fortls', 'omnisharp' }
})

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Global LSP keymaps (set on_attach for all servers)
local on_attach = function(client, bufnr)
  local buf_map = function(mode, lhs, rhs, desc)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
  end
  buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', 'Go to definition')
  buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Go to declaration')
  buf_map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Go to implementation')
end

local util = require("lspconfig.util")

lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = function(fname)
    -- search for standard markers; if none, use your HOME dir
    return util.root_pattern(
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      ".git",
      "pyrightconfig.json"
    )(fname) or vim.loop.os_homedir()
  end,
})

lspconfig.clangd.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.zls.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.bashls.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.jdtls.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.gopls.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.kotlin_language_server.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.asm_lsp.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.fortls.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.omnisharp.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.dartls.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.dartls.setup({ 
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "dart", "language-server", "--protocol=lsp" }
})

-- Set terminal colors to match theme
vim.g.terminal_color_0 = "#1a1b26"
vim.g.terminal_color_1 = "#f7768e"
vim.g.terminal_color_2 = "#9ece6a"
vim.g.terminal_color_3 = "#e0af68"
vim.g.terminal_color_4 = "#7aa2f7"
vim.g.terminal_color_5 = "#bb9af7"
vim.g.terminal_color_6 = "#7dcfff"
vim.g.terminal_color_7 = "#c0caf5"
vim.g.terminal_color_8 = "#414868"
vim.g.terminal_color_9 = "#f7768e"
vim.g.terminal_color_10 = "#9ece6a"
vim.g.terminal_color_11 = "#e0af68"
vim.g.terminal_color_12 = "#7aa2f7"
vim.g.terminal_color_13 = "#bb9af7"
vim.g.terminal_color_14 = "#7dcfff"
vim.g.terminal_color_15 = "#c0caf5"

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- Rust configuration
vim.g.rustfmt_autosave = true  -- Enable automatic formatting on save
vim.g.rust_recommended_style = true

-- Set colorscheme
-- vim.cmd('colorscheme cyberdream')
vim.cmd('colorscheme onedark')

vim.cmd([[
autocmd FileType dart setlocal expandtab tabstop=2 shiftwidth=2
]])

-- Better tab management
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tc', ':tabclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>to', ':tabonly<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tm', ':tabmove<CR>', { noremap = true, silent = true })

-- Window resizing
vim.api.nvim_set_keymap('n', '<M-Up>', ':resize -2<CR>', { noremap = true, silent = true })

-- Terminal shortcuts
-- Fix terminal escape sequences for Windows
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })


-- Horizontal and vertical splits (using Alt+Up/Down)
vim.api.nvim_set_keymap('n', '<leader>v', ':vsplit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-Down>', ':split<CR>', { noremap = true, silent = true })

-- Markdown Preview shortcut
-- vim.api.nvim_set_keymap("n", "<leader>mp", ":Glow<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>mm', ':RenderMarkdown toggle<CR>', { noremap = true, silent = true })


-- Replace all mapping using leader key
vim.api.nvim_set_keymap('n', '<leader>r>', ':%s/<C-r><C-w>/new/g<Left><Left>', { noremap = true, silent = false })

-- NERDTree keybindings
vim.api.nvim_set_keymap('n', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>n', ':NERDTreeFocus<CR>', { noremap = true, silent = true })

-- Copy the current line down.
vim.api.nvim_set_keymap('n', '<C-d>', 'yyp', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-d>', 'yyp', { noremap = true, silent = true })

-- Codeium settings and keybindings
vim.g.codeium_enabled = true
vim.g.codeium_disable_bindings = 1
vim.api.nvim_set_keymap('i', '<C-g>', 'codeium#Accept()', { expr = true, noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-;>', '<Cmd>call codeium#CycleCompletions(1)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-,>', '<Cmd>call codeium#CycleCompletions(-1)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-x>', '<Cmd>call codeium#Clear()<CR>', { noremap = true, silent = true })

-- File-specific settings
vim.cmd([[
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4
autocmd FileType rust setlocal expandtab tabstop=4 shiftwidth=4
autocmd FileType cpp setlocal expandtab tabstop=2 shiftwidth=2
autocmd FileType c setlocal expandtab tabstop=2 shiftwidth=2
]])

-- Set delete operations to use the "black hole" register
vim.api.nvim_set_keymap('n', 'dd', '"_dd', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'd', '"_d', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'X', '"_X', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'x', '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'D', '"_D', { noremap = true, silent = true })

-- Word movement with Ctrl+Left/Right
vim.api.nvim_set_keymap('n', '<C-Left>', 'b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Right>', 'w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-Left>', '<C-o>b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-Right>', '<C-o>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-Left>', 'b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-Right>', 'w', { noremap = true, silent = true })

-- Delete word before cursor with Ctrl+Backspace
-- Windows terminals often send <C-H> for Ctrl+Backspace
vim.api.nvim_set_keymap('i', '<C-BS>', '<C-w>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-H>', '<C-w>', { noremap = true, silent = true }) -- Alternative mapping

-- Delete word after cursor with Ctrl+Delete
vim.api.nvim_set_keymap('i', '<C-Del>', '<C-o>dw', { noremap = true, silent = true })

-- Also add normal mode mappings for consistency
vim.api.nvim_set_keymap('n', '<C-BS>', 'db', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-H>', 'db', { noremap = true, silent = true }) -- Alternative mapping
vim.api.nvim_set_keymap('n', '<C-Del>', 'dw', { noremap = true, silent = true })


-- Map Ctrl+F for searching (instead of '/')
vim.api.nvim_set_keymap('n', '<C-f>', '/', { noremap = true })

-- Make sure tab completion works properly in Windows
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true, noremap = true })

-- Telescope bindings
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true, silent = true })

-- Copy and Paste Keybindings (using system clipboard)
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-x>', '"+d', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-x>', '"+d', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-v>', '"+p', { noremap = true, silent = true })

-- Undo and Redo with Ctrl+Z and Ctrl+Y (Windows standard)
vim.api.nvim_set_keymap('n', '<C-z>', ':u<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-z>', '<C-o>:u<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-y>', ':redo<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-y>', '<C-o>:redo<CR>', { noremap = true, silent = true })
-- Also keep Ctrl+Shift+Z for users who prefer that
vim.api.nvim_set_keymap('n', '<C-S-z>', ':redo<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-S-z>', '<C-o>:redo<CR>', { noremap = true, silent = true })

-- Alt keys
vim.api.nvim_set_keymap('n', '<A-Up>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-Down>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-Up>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-Down>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-Up>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-Down>', ':m .+1<CR>==', { noremap = true, silent = true })
-- Windows doesn't use Command key (D), using Ctrl+Alt instead
vim.api.nvim_set_keymap('n', '<C-A-Left>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-A-Right>', '<C-w>l', { noremap = true, silent = true })

-- Save and Quit keybindings using Ctrl+S and Ctrl+Q
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-q>', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-q>', '<Esc>:q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-q>', '<Esc>:q<CR>', { noremap = true, silent = true })

-- Normal mode: Toggle fold under cursor
vim.api.nvim_set_keymap('n', '<leader>z', 'za', { noremap = true, silent = true })

-- Visual mode: Create fold over the selected lines
vim.api.nvim_set_keymap('v', '<leader>z', 'zf', { noremap = true, silent = true })

-- Ctrl + A to select all text
vim.api.nvim_set_keymap('n', '<C-a>', 'ggVG', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-a>', 'ggVG', { noremap = true, silent = true })

local contentReference = {}
contentReference["oaicite:0"] = { index = 0 }
