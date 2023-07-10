call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'echasnovski/mini.nvim'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'ggandor/lightspeed.nvim'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'MunifTanjim/nui.nvim'
Plug 'xeluxee/competitest.nvim'
Plug 'EdenEast/nightfox.nvim'
Plug 'liuchengxu/vista.vim'

call plug#end()

set number
set nobackup
set nowritebackup

set updatetime=300

set signcolumn=yes

set tabstop=2
set shiftwidth=2
set expandtab

let g:vista_default_executive = 'coc'

let g:coc_node_path = '/usr/local/bin/node'

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

:command CP silent exec "!pbcopy < %"

"colorscheme tokyonight
colorscheme nightfox

lua << END
require('lualine').setup({
  options = {
    theme = 'tokyonight'
  }
})
require('mini.files').setup({
  mappings = {
    close       = 'q',
    go_in       = '',
    go_in_plus  = 'l',
    go_out      = 'h',
    go_out_plus = 'H',
    reset       = '<BS>',
    show_help   = 'g?',
    synchronize = '=',
    trim_left   = '<',
    trim_right  = '>',
  }
})
vim.keymap.set( 'n', '-', function() MiniFiles.open() end)
vim.keymap.set("n", "<c-P>",
  "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
vim.keymap.set("n", "<c-T>",
  "<cmd>execute 'edit' CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': 'file://'.expand(\"%:p\")})<CR>", { silent = true })
require('competitest').setup(
  {
    runner_ui = {
      interface = "split"
    },
    testcases_use_single_file = true
  }
)
END

nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
xnoremap cc <plug>NERDCommenterComment
xnoremap c<space> <plug>NERDCommenterToggle
xnoremap cn <plug>NERDCommenterNested

nnoremap <C-CR> :CompetiTestRun<CR>

:command CD CompetiTestReceive problem
:command CE CompetiTestEdit
:command CA CompetiTestAdd
:command CX CompetiTestDelete

