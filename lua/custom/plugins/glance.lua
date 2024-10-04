return {
  "dnlhc/glance.nvim",
  cmd = "Glance",
  ---@class GlanceOpts
  opts = {
    border = {
      enable = true,
      top_char = "―",
      bottom_char = "―",
    },
    vim.keymap.set('n', 'gdd', '<CMD>Glance definitions<CR>'),
    vim.keymap.set('n', 'grr', '<CMD>Glance references<CR>'),
    vim.keymap.set('n', 'gyy', '<CMD>Glance type_definitions<CR>'),
    vim.keymap.set('n', 'gmm', '<CMD>Glance implementations<CR>')
  },
}
