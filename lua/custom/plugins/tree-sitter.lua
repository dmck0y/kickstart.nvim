return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local languages = {
      'c',
      'cpp',
      'go',
      'lua',
      'python',
      'rust',
      'tsx',
      'typescript',
      'vimdoc',
      'vim',
      'zig',
      'odin',
    }

    require('nvim-treesitter').setup()
    require('nvim-treesitter').install(languages)

    vim.api.nvim_create_autocmd('FileType', {
      pattern = languages,
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        local ft = vim.bo.filetype
        if ft == '' or vim.tbl_contains(languages, ft) then
          return
        end

        local installed = require('nvim-treesitter').get_installed('parsers')
        if not vim.tbl_contains(installed, ft) then
          local available = require('nvim-treesitter').get_available()
          if vim.tbl_contains(available, ft) then
            require('nvim-treesitter').install({ ft })
            vim.treesitter.start()
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end
      end,
    })
  end,
}
