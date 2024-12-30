call plug#begin('~/.local/share/nvim/plugged')  " Changed plugin directory to Linux standard

" Codeium Plug
Plug 'Exafunction/codeium.vim'

" Themes
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'ghifarit53/tokyonight-vim'
Plug 'navarasu/onedark.nvim'

" File tree explorer
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }

" Autopairs for brackets
Plug 'windwp/nvim-autopairs'

" Language Support
Plug 'vim-python/python-syntax'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'ziglang/zig.vim'
Plug 'rust-lang/rust.vim'

" LSP And AutoCompletion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'     " Added for path completion
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'  " Added for more snippets

" Commenting
Plug 'numToStr/Comment.nvim'

" Telescope and dependencies
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" Treesitter for better syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Additional UI improvements
Plug 'kyazdani42/nvim-web-devicons'

" Status line
Plug 'nvim-lualine/lualine.nvim'

call plug#end()

" Use system Python path for Arch Linux
let g:python3_host_prog = '/usr/bin/python3'

" Theme configuration
let g:tokyonight_style = 'night'
let g:tokyonight_enable_italic = 1
let g:onedark_config = {
    \ 'style': 'darker',
\}

" Rust configuration
let g:rustfmt_autosave = 1  " Enable automatic formatting on save
let g:rust_recommended_style = 1

colorscheme onedark

" Basic settings
set number
set mouse=a
set tabstop=4
set encoding=UTF-8
set autoindent
set clipboard=unnamedplus  " Use system clipboard on Linux
set undofile
set shiftwidth=4
set smartindent
set termguicolors
set cursorline
set showmatch
set wildmenu
set wildmode=list:longest
set hidden
set foldmethod=syntax
set foldlevelstart=99
set timeoutlen=500
set updatetime=300
set scrolloff=8
set signcolumn=yes

" Word movement with Shift+Arrow
nnoremap <C-Left> b
nnoremap <C-Right> w
inoremap <C-Left> <C-o>b
inoremap <C-Right> <C-o>w
vnoremap <C-Left> b
vnoremap <C-Right> w

filetype plugin indent on
syntax on

lua << EOF
-- Autopairs setup
require('nvim-autopairs').setup{
    check_ts = true,
    enable_check_bracket_line = true
}

-- LSP configuration
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Define on_attach function for LSP
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- LSP Keybindings
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end

-- Rust LSP setup (rust-analyzer)
lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = {
                command = "clippy",
            },
            cargo = {
                allFeatures = true,
            },
            procMacro = {
                enable = true
            },
        }
    }
})

-- Python LSP (pyright)
lspconfig.pyright.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace"
            }
        }
    }
})

-- C/C++ LSP Configuration
lspconfig.clangd.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {
        "clangd",
        "--background-index",
        "--suggest-missing-includes",
        "--clang-tidy",
        "--header-insertion=iwyu",
    }
})

-- Zig LSP
lspconfig.zls.setup({
    capabilities = capabilities,
    on_attach = on_attach
})

-- Set up nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    }),
    experimental = {
        ghost_text = true,
    }
})

-- Configure treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { "python", "cpp", "c", "rust", "lua", "vim", "zig" },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    }
}

-- Comment.nvim setup
require('Comment').setup()

-- Status line setup
require('lualine').setup {
    options = {
        theme = 'onedark',
        section_separators = '',
        component_separators = '|'
    }
}
EOF

" Codeium settings
let g:codeium_enabled = v:true
let g:codeium_disable_bindings = 1

" Custom keybindings for Codeium
imap <script><silent><nowait><expr> <C-g> codeium#Accept()
imap <C-;>   <Cmd>call codeium#CycleCompletions(1)<CR>
imap <C-,>   <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <C-x>   <Cmd>call codeium#Clear()<CR>

" File-specific settings
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4
autocmd FileType rust setlocal expandtab tabstop=4 shiftwidth=4
autocmd FileType cpp setlocal expandtab tabstop=2 shiftwidth=2
autocmd FileType c setlocal expandtab tabstop=2 shiftwidth=2

" Keybindings
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFocus<CR>

" Script running (adjusted for Linux paths)
command! R w | !python %
command! Cpp execute 'w | !g++ -o "' . expand('%:p:r') . '" "%:p" && "' . expand('%:p:r') . '"'
command! C execute 'w | !gcc -o "' . expand('%:p:r') . '" "%:p" && "' . expand('%:p:r') . '"'

" Telescope bindings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Copy and Paste Keybindings (using system clipboard)
vnoremap <C-c> "+y
vnoremap <C-x> "+d
inoremap <C-v> <C-r>+
nnoremap <C-c> "+y
nnoremap <C-x> "+d
nnoremap <C-v> "+p

" Commenting (both Ctrl + / and Ctrl + _ for better compatibility)
nnoremap <C-_> :lua require('Comment.api').toggle.linewise.current()<CR>
inoremap <C-_> <Esc>:lua require('Comment.api').toggle.linewise.current()<CR>i
nnoremap <C-/> :lua require('Comment.api').toggle.linewise.current()<CR>
inoremap <C-/> <Esc>:lua require('Comment.api').toggle.linewise.current()<CR>i

" Undo/Redo
" Undo with Ctrl + z
nnoremap <C-z> u
inoremap <C-z> <C-o>u

" Redo with Ctrl + Shift + z
nnoremap <C-S-z> <C-r>
inoremap <C-S-z> <C-o><C-r>

" Delete whole line with Ctrl + y in insert mode
inoremap <C-y> <C-o>dd
