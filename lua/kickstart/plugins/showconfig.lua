return {
  dir = '/Users/pawelzapasnik/Workspace/WP/CDP/cdp/tools/showconfig',
  opts = {
    format = 'compact', -- "json" is default but it takes too many lines
    showconfig_binary_path = '/Users/pawelzapasnik/Workspace/WP/CDP/cdp/tools/showconfig/showconfig',
  },
  keys = {
    { '<leader>c', ':CdpShowConfig<CR>', mode = 'n' },
  },
  cmd = {
    'CdpShowConfig',
  },
}
