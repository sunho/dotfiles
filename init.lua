local keyset = vim.keymap.set
local command = vim.api.nvim_command
local create_command = vim.api.nvim_create_user_command

command([[
call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'echasnovski/mini.nvim'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'ggandor/lightspeed.nvim'
Plug 'tpope/vim-fugitive'
Plug 'MunifTanjim/nui.nvim'
Plug 'xeluxee/competitest.nvim'
Plug 'EdenEast/nightfox.nvim'
Plug 'liuchengxu/vista.vim'

call plug#end()
]])

vim.g.vista_default_executive = 'coc'

-- Autocomplete
function _G.check_back_space()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

command('set number')
command('set nobackup')
command('set nowritebackup')
command('set updatetime=300')
command('set signcolumn=yes')
command('set tabstop=2')
command('set shiftwidth=2')
command('colorscheme nightfox')

keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

keyset("n", "<C-H>", "<C-W>h")
keyset("n", "<C-J>", "<C-W>j")
keyset("n", "<C-K>", "<C-W>k")
keyset("n", "<C-L>", "<C-W>l")
keyset("n", "<C-CR>", ":CompetiTestRun<CR>")

create_command('GL', 'G log -1000', {})
create_command('CR', 'CompetiTestReceive problem', {})
create_command('CE', 'CompetiTestEdit', {})
create_command('CA', 'CompetiTestAdd', {})
create_command('CD', 'CompetiTestDelete', {})
create_command('VS', 'Vista', {})
create_command('CP', 'silent exec "!pbcopy < %"', {})

require('lualine').setup({
  options = {
    theme = 'tokyonight'
  }
})

require('mini.files').setup({
  mappings = {
    close       = '<Esc>',
    go_in       = '',
    go_in_plus  = 'l',
    go_out      = 'h',
    go_out_plus = 'H',
    reset       = '<BS>',
    show_help   = 'g?',
    synchronize = '=',
    trim_left   = '<',
    trim_right  = '>',
  },
  options = {
    use_as_default_explorer = false,
    permanent_delete = false
  }
})

require('mini.comment').setup()

require("mini.surround").setup({
  mappings = {
    add = '<C-s>', -- Add surrounding in Normal and Visual modes
    delete = '<C-w>', -- Delete surrounding
    find = '', -- Find surrounding (to the right)
    find_left = '', -- Find surrounding (to the left)
    highlight = '', -- Highlight surrounding
    replace = '<C-r>', -- Replace surrounding
    update_n_lines = '', -- Update `n_lines`

    suffix_last = 'l', -- Suffix to search with "prev" method
    suffix_next = 'n', -- Suffix to search with "next" method
  }
})

require('competitest').setup(
  {
    runner_ui = {
      interface = "split"
    },
    testcases_use_single_file = true,
  }
)

keyset( 'n', '-', function() MiniFiles.open() end)
keyset("n", "<c-P>",
  "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
keyset("n", "<c-T>",
  "<cmd>execute 'edit' CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': 'file://'.expand(\"%:p\")})<CR>", { silent = true })

-- stop netrw from showing
command('silent! autocmd! FileExplorer *')
command('autocmd VimEnter * ++once silent! autocmd! FileExplorer *')


