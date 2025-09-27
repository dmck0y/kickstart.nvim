-- Vim options
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
vim.opt.laststatus = 3
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
vim.opt.shortmess:append("WIc")
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spelllang = { 'en' }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200
vim.opt.wildmode = 'longest:full,full'
vim.opt.winminwidth = 5
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.breakindent = true

vim.g.markdown_recommended_style = 0
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0

-- Utility function for keymaps
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    for k, v in pairs(opts) do
      options[k] = v
    end
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Better default keymaps
map({ 'n', 'v' }, '<Space>', '<Nop>')
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Custom keymaps
map('i', 'jj', '<Esc>')
map('n', '<leader>r', ':so %<CR>')
map('n', '<leader>fw', 'viW*')

