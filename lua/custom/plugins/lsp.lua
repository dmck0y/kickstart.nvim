return {
  {
    "neovim/nvim-lspconfig", -- Still needed as a dependency for Mason
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gdd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
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
          
          -- LazyGit
          map('<leader>gg', ':LazyGit<CR>', 'Open LazyGit')

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

      -- LSP servers configuration
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              completion  = { callSnippet = 'Replace' },
            },
          },
        },
        rust_analyzer   = {},
        gopls           = {},
        ts_ls           = {},
        zls             = {},
        ols             = {},
        clangd          = {
          cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes",
            "--clang-tidy",
            "-I/opt/homebrew/Cellar/raylib/5.0/include"
          },
        },
        html            = {
          filetypes = { 'html', 'twig', 'hbs', 'templ' },
        },
      }

      -- Configure and enable each server with the Neovim 0.11+ LSP API
      for name, config in pairs(servers) do
        local opts = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, config or {})

        vim.lsp.config(name, opts)
        vim.lsp.enable(name)
      end

      -- Godot LSP
      vim.lsp.config('gdscript', {
        cmd = { "nc", "localhost", "6005" },
      })

      -- Auto-detect Godot projects
      local gdproject = io.open(vim.fn.getcwd()..'/project.godot', 'r')
      if gdproject then
        io.close(gdproject)
        local socket = './godothost'
        if socket then
          vim.fn.delete(socket)
        end
        vim.fn.serverstart(socket)
        vim.lsp.enable('gdscript')
      end

      -- Godot settings
      vim.g.godot_executable = '/Applications/Godot.app'
      
      -- Godot keybindings
      vim.keymap.set('n', '<F4>', ':GodotRunLast<CR>', { noremap = true, buffer = true })
      vim.keymap.set('n', '<F5>', ':GodotRun<CR>', { noremap = true, buffer = true })
      vim.keymap.set('n', '<F6>', ':GodotRunCurrent<CR>', { noremap = true, buffer = true })
      vim.keymap.set('n', '<F7>', ':GodotRunFZF<CR>', { noremap = true, buffer = true })
      
      -- Filetype configurations
      vim.filetype.add({ extension = { templ = "templ" } })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = "*.templ", command = "set filetype=templ" })
      vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*.templ" }, callback = vim.lsp.buf.format })
    end,
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
  },
}
