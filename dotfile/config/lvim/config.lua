--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]
-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 4
vim.opt.relativenumber = false
vim.opt.cmdheight = 0
vim.opt.guifont = "SpaceMono Nerd Font"
vim.opt.clipboard = "unnamedplus"
-- general
lvim.format_on_save = {
  enabled = true,
  timeout = 1000,
}
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-Right>"] = "e"
lvim.keys.normal_mode["<C-Left>"] = "b"
lvim.keys.normal_mode["<C-Up>"] = false
lvim.keys.normal_mode["<C-Down>"] = false
lvim.keys.normal_mode["<C-a>"] = "ggVG"
lvim.keys.insert_mode["<C-a>"] = "ggVG"
lvim.keys.visual_mode["<C-a>"] = "ggVG"
lvim.keys.normal_mode["<C-c>"] = "+y"
lvim.keys.insert_mode["<C-c>"] = "+y"
lvim.keys.visual_mode["<C-c>"] = "+y"
lvim.keys.normal_mode["<C-v>"] = "+p"
lvim.keys.insert_mode["<C-v>"] = "+p"
lvim.keys.visual_mode["<C-v>"] = "+p"
-- Change theme settings
lvim.colorscheme = "rose-pine"
vim.o.background = "light"
lvim.transparent_window = true

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.lualine.sections.lualine_a = { "mode", "searchcount", "lsp", "treesitter", "python_env", "diff" }
lvim.builtin.lualine.sections.lualine_b = { "branch" }
lvim.builtin.lualine.sections.lualine_c = { "diagnostics" }
lvim.builtin.lualine.sections.lualine_x = { "location", "encoding", "filetype" }
lvim.builtin.lualine.sections.lualine_y = { "spaces" }
lvim.builtin.lualine.sections.lualine_z = { "progress" }


-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)
-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  --   { command = "stylua" },
  {
    command = "prettier",
    extra_args = { "--print-width", "100" },
    filetypes = { "typescript", "typescriptreact", "yaml", "xml", "html", "javascript" },
  },
}
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
  {
    command = "shellcheck",
    args = { "--severity", "warning" },
  },
}

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
lvim.plugins = {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    "wfxr/code-minimap",
    "hrsh7th/nvim-cmp",
    "rose-pine/neovim",
    { "MunifTanjim/prettier.nvim" },
    { "uga-rosa/ccc.nvim" },
    { "melkster/modicator.nvim" },
    { "RRethy/vim-illuminate" },
    { "NvChad/nvim-colorizer.lua" },
    { "junegunn/fzf" },
    { "junegunn/fzf.vim" },
    { "windwp/nvim-ts-autotag" },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    { "nvim-treesitter/nvim-treesitter-context" },
    { "mattn/vim-gist" },
    { "sindrets/diffview.nvim" },
    { "f-person/git-blame.nvim" },
    { "nacro90/numb.nvim" },
    { "nvim-pack/nvim-spectre" },
    { "kevinhwang91/rnvimr" },
    { "nvim-telescope/telescope-fzy-native.nvim" },
    { "nvim-telescope/telescope-project.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "ellisonleao/glow.nvim" },
    { "karb94/neoscroll.nvim" },
    { "folke/todo-comments.nvim" },
    { "tpope/vim-surround" },
    { "phaazon/hop.nvim" },
    { "tzachar/local-highlight.nvim" },
  }
}

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--  pattern = "zsh",
--  callback = function()
--    -- let treesitter use bash highlight for zsh files as well
--    require("nvim-treesitter.highlight").attach(0, "bash")
--  end,
--})
