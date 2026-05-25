return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "lua-language-server",
        "rust-analyzer", 
        "gopls",
        "typescript-language-server",
        "zls",
        "ols",
        "clangd",
        "html-lsp",
        
        -- Formatters (not LSP servers)  
        "prettier",
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- Only ensure LSP servers are installed, not formatters
      ensure_installed = {
        "lua_ls",
        "rust_analyzer", 
        "gopls",
        "ts_ls",
        "zls",
        "ols", 
        "clangd",
        "html",
      },
      automatic_installation = false,  -- Disable automatic installation to prevent stylua configuration
      handlers = {},  -- Empty handlers to prevent automatic setup
    },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
}