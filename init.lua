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


-- Initialize lazy.nvim
require('lazy').setup({
  -- Plugin manager

	  'folke/lazy.nvim',

  -- Codeium plugin
  { 'Exafunction/codeium.vim' },

  {'terrortylor/nvim-comment'},

  -- Themes
  { 'dracula/vim', as = 'dracula' },
  { 'ghifarit53/tokyonight-vim' },
  { 'navarasu/onedark.nvim' },

  -- File tree explorer
  { 'preservim/nerdtree', cmd = 'NERDTreeToggle' },

  -- Autopairs for brackets
  { 'windwp/nvim-autopairs' },

  -- Language support
  { 'vim-python/python-syntax' },
  { 'octol/vim-cpp-enhanced-highlight' },
  { 'ziglang/zig.vim' },
  { 'rust-lang/rust.vim' },

  -- Autocompletion
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'L3MON4D3/LuaSnip' },
  { 'rafamadriz/friendly-snippets' },

  -- LSP Configurations
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },

  -- LSP and Autocompletion
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'L3MON4D3/LuaSnip' },
  { 'rafamadriz/friendly-snippets' },

  -- Commenting
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

  {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require('nvim-autopairs').setup()
        end,
    },
})

require('nvim-autopairs').setup({
    enable_check_bracket_line = true,
})



-- Basic settings
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.tabstop = 4
vim.opt.encoding = 'UTF-8'
vim.opt.autoindent = true
vim.opt.clipboard = 'unnamedplus'  -- Use system clipboard on Linux
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
vim.g.onedark_config = {
  style = 'darker',
}

require('nvim_comment').setup({
  line_mapping = '<C-_>',
  operator_mapping = '<C-_>',
  comment_chunk_text_object = 'ic',
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
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif npairs.check_insert_char() then
                npairs.autopairs_insert()
            else
                fallback()
            end
        end,
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

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Python (pyright)
lspconfig.pyright.setup({
  capabilities = capabilities,
})

-- C/C++ (clangd)
lspconfig.clangd.setup({
  capabilities = capabilities,
})

-- Zig (zls)
lspconfig.zls.setup({
  capabilities = capabilities,
})

-- Bash (bashls)
lspconfig.bashls.setup({
  capabilities = capabilities,
})

-- Java (jdtls)
lspconfig.jdtls.setup({
  capabilities = capabilities,
})

-- Go (gopls)
lspconfig.gopls.setup({
  capabilities = capabilities,
})

-- Kotlin (kotlin_language_server)
lspconfig.kotlin_language_server.setup({
  capabilities = capabilities,
})

-- Assembly (asm_lsp)
lspconfig.asm_lsp.setup({
  capabilities = capabilities,
})

-- Fortran (fortls)
lspconfig.fortls.setup({
  capabilities = capabilities,
})

-- C# (omnisharp)
lspconfig.omnisharp.setup({
  capabilities = capabilities,
})

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'pyright', 'clangd', 'zls', 'bashls', 'jdtls', 'gopls', 'kotlin_language_server', 'asm_lsp', 'fortls', 'omnisharp' },
})


-- Rust configuration
vim.g.rustfmt_autosave = true  -- Enable automatic formatting on save
vim.g.rust_recommended_style = true

-- Set colorscheme
vim.cmd('colorscheme onedark')

-- Keybindings
vim.api.nvim_set_keymap('n', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>n', ':NERDTreeFocus<CR>', { noremap = true, silent = true })

-- Codeium settings
vim.g.codeium_enabled = true
vim.g.codeium_disable_bindings = 1

-- Custom keybindings for Codeium
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

-- Word movement with Shift+Arrow
vim.api.nvim_set_keymap('n', '<C-Left>', 'b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Right>', 'w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-Left>', '<C-o>b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-Right>', '<C-o>w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-Left>', 'b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-Right>', 'w', { noremap = true, silent = true })

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
vim.api.nvim_set_keymap('v', '<C-q>', ':q', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-q>', ':q', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', ':w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-s>', ':w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-s>', ':w', { noremap = true, silent = true })

local contentReference = {}
contentReference["oaicite:0"] = {index = 0}

 
