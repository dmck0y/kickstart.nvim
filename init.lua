--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!


  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]

require "custom.keymaps"

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'mg979/vim-visual-multi' },

  -- NOTE: First, some plugins that don't require any configuration
  { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
  { 'neovim/nvim-lspconfig' },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/nvim-cmp" },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
  },

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-surround',

  -- auto complete
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
  'MunifTanjim/nui.nvim',
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  'Tetralux/odin.vim',
  'MunifTanjim/nui.nvim',
  "christoomey/vim-tmux-navigator",
  "ThePrimeagen/harpoon",
  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },
  'habamax/vim-godot',
  --
  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = 'custom.plugins' },
}, {})

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
end)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('<leader>cm', ':Mason<CR>', '[C-M] Open Mason')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    map('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

local servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        },
        completion = {
          callSnippet = 'Replace',
        },
        -- Uncomment to disable noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
  rust_analyzer = {},
  tsserver = {},
  gopls = {},
  zls = {},
  ols = {},
  clangd = {
    cmd = { "clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy", "-I/opt/homebrew/Cellar/raylib/5.0/include" },
  },
  html = { filetypes = { 'html', 'twig', 'hbs', 'templ' } },
  templ = { filetypes = { 'html', 'templ' } },
}

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { "lua_ls", "rust_analyzer", "tsserver", "gopls", "zls", "ols", "clangd", "html", "templ" },
  handlers = {
    function(server_name)
      -- lsp_zero.default_setup()
      local server_config = servers[server_name] or {}
      server_config.capabilities = vim.tbl_deep_extend('force', capabilities, server_config.capabilities or {})
      require('lspconfig')[server_name].setup(server_config)
    end,
  },
})


local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'path' },
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
--
-- Add a new file mark
vim.api.nvim_set_keymap('n', '<leader>ma', [[<Cmd>lua require("harpoon.mark").add_file()<CR>]],
  { noremap = true, silent = true })

-- Toggle the quick menu for marks
vim.api.nvim_set_keymap('n', '<leader>mt', [[<Cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>]],
  { noremap = true, silent = true })

-- Navigate to a specific file mark
vim.api.nvim_set_keymap('n', '<leader>m1', [[<Cmd>lua require("harpoon.ui").nav_file(1)<CR>]],
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>m2', [[<Cmd>lua require("harpoon.ui").nav_file(2)<CR>]],
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>m3', [[<Cmd>lua require("harpoon.ui").nav_file(3)<CR>]],
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>m4', [[<Cmd>lua require("harpoon.ui").nav_file(4)<CR>]],
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>m5', [[<Cmd>lua require("harpoon.ui").nav_file(5)<CR>]],
  { noremap = true, silent = true })
-- ... etc.
--
vim.api.nvim_set_keymap('n', '<leader>n', [[<Cmd>lua require("harpoon.ui").nav_next()<CR>]],
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>p', [[<Cmd>lua require("harpoon.ui").nav_prev()<CR>]],
  { noremap = true, silent = true })

-- Go to terminal 1
vim.api.nvim_set_keymap('n', '<leader>t1', [[<Cmd>lua require("harpoon.term").gotoTerminal(1)<CR>]],
  { noremap = true, silent = true })

vim.filetype.add({ extension = { templ = "templ" } })
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = "*.odin", command = "set filetype=odin" })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = "*.templ", command = "set filetype=templ" })
vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*.templ" }, callback = vim.lsp.buf.format })

--Godot globals
vim.g.godot_executable = '/Applications/Godot.app'

--Godot keybindings
vim.keymap.set('n', '<F4>', ':GodotRunLast<CR>', { noremap = true, buffer = true })
vim.keymap.set('n', '<F5>', ':GodotRun<CR>', { noremap = true, buffer = true })
vim.keymap.set('n', '<F6>', ':GodotRunCurrent<CR>', { noremap = true, buffer = true })
vim.keymap.set('n', '<F7>', ':GodotRunFZF<CR>', { noremap = true, buffer = true })

require 'lspconfig'.gdscript.setup {
  cmd = { "nc", "localhost", "6005" },
}

--Oil keybindings
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
