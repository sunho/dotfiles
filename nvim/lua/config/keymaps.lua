-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<leader><space>", "<cmd>Buffers<cr>")
map("n", "<leader>gc", "<cmd>Commits<cr>")
map("n", "<leader>gs", "<cmd>GFiles?<cr>")
map("n", "<c-p>", "<cmd>Files<cr>")
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>")
-- map("n", "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>")
map("n", "<c-cr>", "<cmd>CompetiTest run<cr>")
map("n", "<c-t>", "<cmd>CocList symbols<cr>")
map("n", "<leader>cR",
  "<cmd>execute 'edit' CocRequest('clangd', 'textDocument/switchSourceHeader', {'uri': 'file://'.expand(\"%:p\")})<CR>", { silent = true })

map("n", "-", function()  end)
map( "i", "jk", "<Esc>")

-- Autocomplete
function _G.check_back_space()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
map("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
map("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
map("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

map("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
map("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})
map("n", "gd", "<Plug>(coc-definition)", {silent = true})
map("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
map("n", "gi", "<Plug>(coc-implementation)", {silent = true})
map("n", "gr", "<Plug>(coc-references)", {silent = true})

-- Buffer history swithcer
function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

function removeElement(array, idx)
	local res = {}
	for i = 1, #array do
		if i ~= idx then
			res[#res+1] = array[i]
		end
	end
	return res
end

buffer_history = {}
buffer_switching = false
buffer_idx = nil

function pushBufferRecord(buf_id)
	local cur = indexOf(buffer_history, buf_id)
	if cur ~= nil then
		buffer_history = removeElement(buffer_history, cur)
	end
	buffer_history[#buffer_history+1] = buf_id
end

function removeBufferRecord(buf_id)
	local cur = indexOf(buffer_history, buf_id)
	if cur ~= nil then
		buffer_history = removeElement(buffer_history, cur)
	end
end

function resetBufferSwitch()
	buffer_idx = nil
end

function initBufferSwitch()
	if buffer_idx == nil then
		buffer_idx = #buffer_history
	end
end

function prevBuffer()
	initBufferSwitch()
	if #buffer_history <= 1 then
		return
	end
	if buffer_idx ~= 1 then
		buffer_idx = buffer_idx - 1
		buffer_switching = true
		vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), buffer_history[buffer_idx])
	end
end

function nextBuffer()
	initBufferSwitch()
	if #buffer_history <= 1 then
		return
	end
	if buffer_idx ~= #buffer_history then
		buffer_idx = buffer_idx + 1
		buffer_switching = true
		vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), buffer_history[buffer_idx])
	end
end

vim.api.nvim_create_autocmd({"BufEnter"}, {
  callback = function(ev)
		if ev.file ~= "" then
			if buffer_switching == false then
				resetBufferSwitch()
				pushBufferRecord(ev.buf)
			end
			buffer_switching = false
		end
  end
})

vim.api.nvim_create_autocmd({"BufDelete"}, {
  callback = function(ev)
		if ev.file ~= "" then
			resetBufferSwitch()
			removeBufferRecord(ev.buf)
		end
  end
})

map( 'n', '<S-Tab>', function() prevBuffer() end)
map( 'n', '<Tab>', function() nextBuffer() end)

local create_command = vim.api.nvim_create_user_command
create_command('CR', 'CompetiTest receive problem', {})
create_command('CC', 'CompetiTest receive contest', {})
create_command('CE', 'CompetiTest edit_testcase', {})
create_command('CA', 'CompetiTest add_testcase', {})
create_command('CD', 'CompetiTest delete_testcase', {})
create_command('CP', 'silent exec ":%y+"', {})

