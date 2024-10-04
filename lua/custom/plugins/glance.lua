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
    vim.keymap.set('n', 'gd', '<CMD>Glance definitions<CR>'),
    vim.keymap.set('n', 'gr', '<CMD>Glance references<CR>'),
    vim.keymap.set('n', 'gy', '<CMD>Glance type_definitions<CR>'),
    vim.keymap.set('n', 'gm', '<CMD>Glance implementations<CR>')
  },
}
