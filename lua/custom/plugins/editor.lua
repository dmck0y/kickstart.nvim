return {
  -- Multiple cursors
  { 'mg979/vim-visual-multi' },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Surround text with brackets, quotes, etc.
  'tpope/vim-surround',

  -- Essential UI library
  'MunifTanjim/nui.nvim',

  -- Tmux navigation
  'christoomey/vim-tmux-navigator',

  -- Harpoon for quick file switching
  {
    'ThePrimeagen/harpoon',
    config = function()
      -- Add a new file mark
      vim.api.nvim_set_keymap('n', '<leader>ma', [[<Cmd>lua require("harpoon.mark").add_file()<CR>]], { noremap = true, silent = true })

      -- Toggle the quick menu for marks
      vim.api.nvim_set_keymap('n', '<leader>mt', [[<Cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>]], { noremap = true, silent = true })

      -- Navigate to specific file marks
      vim.api.nvim_set_keymap('n', '<leader>m1', [[<Cmd>lua require("harpoon.ui").nav_file(1)<CR>]], { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>m2', [[<Cmd>lua require("harpoon.ui").nav_file(2)<CR>]], { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>m3', [[<Cmd>lua require("harpoon.ui").nav_file(3)<CR>]], { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>m4', [[<Cmd>lua require("harpoon.ui").nav_file(4)<CR>]], { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>m5', [[<Cmd>lua require("harpoon.ui").nav_file(5)<CR>]], { noremap = true, silent = true })

      -- Navigate next/previous
      vim.api.nvim_set_keymap('n', '<leader>n', [[<Cmd>lua require("harpoon.ui").nav_next()<CR>]], { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>p', [[<Cmd>lua require("harpoon.ui").nav_prev()<CR>]], { noremap = true, silent = true })

      -- Go to terminal 1
      vim.api.nvim_set_keymap('n', '<leader>t1', [[<Cmd>lua require("harpoon.term").gotoTerminal(1)<CR>]], { noremap = true, silent = true })
    end,
  },
}
