return {
  'timtro/glslView-nvim',
  ft = 'glsl',
  config = function()
    require('glslView').setup {
      viewer_path = 'glslViewer',
      args = { '-l' },
    }
  end,
}
