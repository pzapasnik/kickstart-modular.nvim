return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod',                     lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { desc = "#dadbod ui toggle" })
    vim.keymap.set("n", "<leader>dc", ":DBUIAddConnection<CR>", { desc = "#dadbod add connection" })
    vim.keymap.set("n", "<leader>df", ":DBUIFindBuffer<CR>", { desc = "#dadbod find buffer" })
    vim.keymap.set("n", "<leader>dr", ":DBUIRenameBuffer<CR>", { desc = "#dadbod rename buffer" })
    vim.keymap.set("n", "<leader>dq", ":DBUILastQueryInfo<CR>", { desc = "#dadbod last query info" })
    vim.keymap.set("n", "<leader>dw", ":DBUI_SaveQuery<CR>", { desc = "#dadbod save query" })
  end,
}
