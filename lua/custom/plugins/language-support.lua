return {
  -- Odin language support
  'Tetralux/odin.vim',
  
  -- Godot support
  'habamax/vim-godot',
  
  -- GLSL syntax highlighting
  'tikhomirov/vim-glsl',
  
  -- Formatter
  {
    'mhartington/formatter.nvim',
    config = function()
      require('formatter').setup({
        filetype = {

          javascript = {
            function()
              return {
                exe = "prettier",
                args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
                stdin = true
              }
            end
          },
          typescript = {
            function()
              return {
                exe = "prettier",
                args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
                stdin = true
              }
            end
          },
          typescriptreact = {
            function()
              return {
                exe = "prettier",
                args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
                stdin = true
              }
            end
          }
        }
      })
      

    end,
  },
}