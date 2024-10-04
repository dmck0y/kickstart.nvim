vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.autowrite = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.conceallevel = 3
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.formatoptions = 'jcroqlnt'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit'
vim.opt.laststatus = 0
vim.opt.list = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize' }
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append { W = true, I = true, c = true }
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spelllang = { 'en' }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200
vim.opt.wildmode = 'longest:full,full'
vim.opt.winminwidth = 5
vim.opt.wrap = false

vim.g.markdown_recommended_style = 0
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0
-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('i', 'jj', '<Esc>')
map('n', '<leader>r', ':so %<CR>')
