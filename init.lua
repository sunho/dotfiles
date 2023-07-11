local keyset = vim.keymap.set
local command = vim.api.nvim_command
local create_command = vim.api.nvim_create_user_command

-- Plug 'EdenEast/nightfox.nvim'
-- Plug 'folke/tokyonight.nvim'
command([[
call plug#begin()

Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'preservim/nerdcommenter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'echasnovski/mini.nvim'
Plug 'ggandor/lightspeed.nvim'
Plug 'tpope/vim-fugitive'
Plug 'liuchengxu/vista.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'MunifTanjim/nui.nvim'
Plug 'xeluxee/competitest.nvim'

call plug#end()
]])

vim.g.vista_default_executive = 'coc'
vim.api.nvim_set_option("clipboard","unnamed")

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
vim.cmd.colorscheme "catppuccin"

keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})

keyset("n", "<C-CR>", ":CompetiTestRun<CR>")

create_command('GL', 'G log -1000', {})
create_command('CR', 'CompetiTestReceive problem', {})
create_command('CE', 'CompetiTestEdit', {})
create_command('CA', 'CompetiTestAdd', {})
create_command('CD', 'CompetiTestDelete', {})
create_command('VS', 'Vista', {})
create_command('CP', 'silent exec ":%y+"', {})

require('lualine').setup({
  options = {
    theme = 'catppuccin'
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

--require("mini.surround").setup({
  --mappings = {
    --add = '<C-s>', -- Add surrounding in Normal and Visual modes
    --delete = '<C-i>', -- Delete surrounding
    --find = '', -- Find surrounding (to the right)
    --find_left = '', -- Find surrounding (to the left)
    --highlight = '', -- Highlight surrounding
    --replace = '', -- Replace surrounding
    --update_n_lines = '', -- Update `n_lines`

    --suffix_last = 'l', -- Suffix to search with "prev" method
    --suffix_next = 'n', -- Suffix to search with "next" method
  --}
--})

require('competitest').setup(
  {
    runner_ui = {
      interface = "split"
    },
		compile_command = {
			cpp       = { exec = 'g++',           args = {'$(FNAME)', '-o', '$(FNOEXT)', '--std=c++20', '-fsanitize=address', '-fsanitize=undefined'} },
		},
    testcases_use_single_file = true,
  }
)

keyset( 'n', '-', function() MiniFiles.open() end)
keyset("n", "<c-T>",
  "<cmd>execute 'edit' CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': 'file://'.expand(\"%:p\")})<CR>", { silent = true })

-- stop netrw from showing
command('silent! autocmd! FileExplorer *')
command('autocmd VimEnter * ++once silent! autocmd! FileExplorer *')

vim.keymap.set( "n", "<space><space>", ":Buffers<CR>")
vim.keymap.set( "n", "<C-P>", ":Files<CR>")
vim.keymap.set( "n", "<S-Tab>", ":bp<CR>")
vim.keymap.set( "n", "<Tab>", ":bn<CR>")
vim.keymap.set( "i", "jk", "<Esc>")

