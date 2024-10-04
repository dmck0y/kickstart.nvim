local lsp_zero = require('lsp-zero')
lsp_zero.extend_lspconfig()

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

-- this is the function that loads the extra snippets to luasnip from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip', keyword_length = 2},
    {name = 'buffer', keyword_length = 3},
  },
  formatting = lsp_zero.cmp_format({details = false}),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})

local config = {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function()
    -- Set up Mason and Mason-LSPConfig
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = { "lua_ls", "rust_analyzer", "tsserver", "gopls", "zls", "ols", "clangd", "html", "templ" }
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Define the LSP servers and their settings
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
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

    -- Set up handlers for LSP servers
    require('mason-lspconfig').setup_handlers({
      function(server_name)
        lsp_zero.default_setup()
        local server_config = servers[server_name] or {}
        server_config.capabilities = vim.tbl_deep_extend('force', capabilities, server_config.capabilities or {})
        require('lspconfig')[server_name].setup(server_config)
      end,
    })

    -- Set up auto commands for LSP
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
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
        map('<leader>gg', ':LazyGit<CR>', 'Open LazyGit')
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

    -- Ensure additional tools are installed
    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, { 'stylua' }) -- Used to format Lua code
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }
  end,
}

