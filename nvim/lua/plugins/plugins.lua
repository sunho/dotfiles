return {
  { "junegunn/fzf" },
  { "junegunn/fzf.vim" },
  { "gfanto/fzf-lsp.nvim" },
  -- {
  --   "neovim/nvim-lspconfig",
  --   init = function()
  --     local keys = require("lazyvim.plugins.lsp.keymaps").get()
  --     local findIndex = function(key)
  --       for i, value in ipairs(keys) do
  --         if value[1] == key then
  --           return i
  --         end
  --       end
  --       return -1
  --     end
  --     -- change a keymap
  --     keys[findIndex("gd")] = { "gd", "<cmd>Definitions<cr>" }
  --     keys[findIndex("gr")] = { "gr", "<cmd>References<cr>" }
  --     keys[findIndex("gI")] = { "gI", "<cmd>Implementations<cr>" }
  --     keys[findIndex("gy")] = { "gy", "<cmd>TypeDefinitions<cr>" }
  --   end,
  --   opts = {
  --     autoformat = false,
  --   },
  -- },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function(_, dashboard)
      local logo = [[
███╗   ██╗███████╗██╗    ██╗     ██████╗  █████╗ ███╗   ███╗███████╗██╗██╗
████╗  ██║██╔════╝██║    ██║    ██╔════╝ ██╔══██╗████╗ ████║██╔════╝██║██║
██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║  ███╗███████║██╔████╔██║█████╗  ██║██║
██║╚██╗██║██╔══╝  ██║███╗██║    ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ╚═╝╚═╝
██║ ╚████║███████╗╚███╔███╔╝    ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗██╗██╗
╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝╚═╝
]]

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Files<CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":History<CR>"),
        dashboard.button("g", " " .. " Find text", ":Ag<CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.sections.lualine_z = opts.sections.lualine_y
      opts.sections.lualine_y = opts.sections.lualine_x
      opts.sections.lualine_x = nil
    end,
  },
  {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
      require("competitest").setup({
        compile_command = {
          cpp = {
            exec = "g++",
            args = { "-Wall", "$(FNAME)", "-g", "--std=c++17", "-fsanitize=address,undefined", "-o", "$(FNOEXT)" },
          },
        },
        runner_ui = {
          interface = "split",
        },
      })
    end,
  },
  {
    'neoclide/coc.nvim', 
    branch = "release"
  }
}
