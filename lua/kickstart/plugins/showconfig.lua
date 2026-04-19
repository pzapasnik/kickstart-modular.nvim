-- CDP tools not only showconfig
return {
  dir = '/Users/pawelzapasnik/Workspace/WP/CDP/cdp/tools/showconfig',
  opts = {
    format = 'compact', -- "json" is default but it takes too many lines
    showconfig_binary_path = '/Users/pawelzapasnik/Workspace/WP/CDP/cdp/tools/showconfig/showconfig',
  },
  keys = {
    { '<leader>c', ':CdpShowConfig<CR>', mode = 'n', { desc = '#CDP Show config' } },
    { '<leader>pm', ':e /Users/pawelzapasnik/Workspace/WP/CDP/cdp/common/marker/marker.go<cr>', mode = 'n', { desc = '#CDP Open marker.go' } },
  },
  cmd = {
    'CdpShowConfig',
  },
}
