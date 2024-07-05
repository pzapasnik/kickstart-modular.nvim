local lspconfig = require('lspconfig')
local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = false,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil
cmp_mappings['<C-f>'] = nil


--lua-language-server config
lsp.configure('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
    },
  },
})


-- require("lsp_signature").setup({})

--htmx config
lspconfig.htmx.setup {}

--TypeScript
-- Use project-local typescript installation if available, fallback to global install
-- assumes typescript installed globally w/ nvm
local function get_typescript_server_path(root_dir)
  local homebrew_ts = "/opt/homebrew/lib/node_modules/typescript/lib"
  -- local global_ts = vim.fn.expand("$NVM_DIR/versions/node/$DEFAULT_NODE_VERSION/lib/node_modules/typescript/lib")
  local project_ts = ""
  local function check_dir(path)
    project_ts = lspconfig.util.path.join(path, "node_modules", "typescript", "lib")
    if lspconfig.util.path.exists(project_ts) then return path end
  end
  if lspconfig.util.search_ancestors(root_dir, check_dir) then
    return project_ts
  else
    return homebrew_ts
  end
end

-- ts/js/vue
lspconfig.volar.setup({
  -- enable "take over mode" for typescript files as well: https://github.com/johnsoncodehk/volar/discussions/471
  filetypes = { "typescript", "javascript", "vue" },
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
})

--golang formaters and linters
lspconfig.gopls.setup({
  settings = {
    gopls = {
      gofumpt = true
    }
  }
})

--elixir formaters and linters
lspconfig.lexical.setup({
  cmd = { "/Users/pawelzapasnik/.local/share/nvim/mason/bin/lexical", "server" },
  root_dir = require("lspconfig.util").root_pattern({ ".git" }),
})

lsp.ensure_installed({
  'tsserver',
  'eslint',
})


lsp.set_preferences({
  sign_icons = {}
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false, desc = "#LSP" }

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
    { buffer = bufnr, remap = false, desc = "#LSP Go to definition" })
  vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end,
    { buffer = bufnr, remap = false, desc = "#LSP Go to implementation" })
  vim.keymap.set("n", "<leader>lt", function() vim.lsp.buf.type_definition() end,
    { buffer = bufnr, remap = false, desc = "#LSP Go to Type definition" })
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
    { buffer = bufnr, remap = false, desc = "#LSP Show documentation / information" })
  vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.workspace_symbol() end,
    { buffer = bufnr, remap = false, desc = "#LSP Search for workspace symbols" })
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end,
    { buffer = bufnr, remap = false, desc = "#LSP Go to next diagnostic" })
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end,
    { buffer = bufnr, remap = false, desc = "#LSP Go to previouse diagnostic" })
  vim.keymap.set("n", "<leader>lc", function() vim.lsp.buf.code_action() end,
    { buffer = bufnr, remap = false, desc = "#LSP Execute code action" })
  vim.keymap.set("n", "<leader>ln", function() vim.lsp.buf.rename() end,
    { buffer = bufnr, remap = false, desc = "#LSP rename symbol and all references" })
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
    { buffer = bufnr, remap = false, desc = "#LSP Show signature help" })
  vim.keymap.set("n", "<leader>ll", ":LspRestart<CR>",
    { buffer = bufnr, remap = false, desc = "#LSP restart" })
end)


vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]] --format on save
local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  sources = {
    formatting.golines,
    formatting.goimports,
    formatting.buf.with({
      args = { "--indent", "2" },
    }),
    formatting.fixjson.with({
      args = { "--indent", "2" },
    }),
  },
  on_attach = function(current_client, bufnr)
    if current_client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            timeout_ms = 2000,
            filter = function(client)
              return client.name == "null-ls"
            end,
            bufnr = bufnr,
          })
        end
      })
    end
  end,
})


lsp.setup()
