return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    config = function()
      require("dapui").setup()

      -- Create DAP commands
      vim.api.nvim_create_user_command("DapUiOpen", function()
        require("dapui").open()
      end, {})

      vim.api.nvim_create_user_command("DapUiClose", function()
        require("dapui").close()
      end, {})

      vim.api.nvim_create_user_command("DapUiToggle", function()
        require("dapui").toggle()
      end, {})

      -- DAP keymaps
      vim.keymap.set('n', '<leader>du', function() require('dapui').toggle() end, { desc = 'Toggle DAP UI' })
      vim.keymap.set('n', '<F1>', function() require('dap').continue() end, { desc = 'DAP continue' })
      vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'DAP step over' })
      vim.keymap.set('n', '<F3>', function() require('dap').step_into() end, { desc = 'DAP step into' })
      vim.keymap.set('n', '<F4>', function() require('dap').step_out() end, { desc = 'DAP step out' })
      vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'DAP toggle breakpoint' })
    end,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {}
  },
}