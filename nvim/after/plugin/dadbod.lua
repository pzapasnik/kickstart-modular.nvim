vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { desc = "#dadbod ui toggle" })
vim.keymap.set("n", "<leader>dc", ":DBUIAddConnection<CR>", { desc = "#dadbod add connection" })
vim.keymap.set("n", "<leader>df", ":DBUIFindBuffer<CR>", { desc = "#dadbod find buffer" })
vim.keymap.set("n", "<leader>dr", ":DBUIRenameBuffer<CR>", { desc = "#dadbod rename buffer" })
vim.keymap.set("n", "<leader>dq", ":DBUILastQueryInfo<CR>", { desc = "#dadbod last query info" })
vim.keymap.set("n", "<leader>dw", ":DBUI_SaveQuery<CR>", { desc = "#dadbod save query" })
local M = {}

local function db_completion()
  require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
end

function M.setup()
  vim.g.db_ui_save_location = vim.fn.stdpath "config" .. require("plenary.path").path.sep .. "db_ui"

  vim.api.nvim_create_autocmd("FileType", {
    pattern = {
      "sql",
    },
    command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = {
      "sql",
      "mysql",
      "plsql",
      "clickhouse",
    },
    callback = function()
      vim.schedule(db_completion)
    end,
  })
end

return M
