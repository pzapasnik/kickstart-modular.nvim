local lspconfig = require('lspconfig')
local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = false,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- require("lsp_signature").setup({})

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




lsp.set_preferences({
  sign_icons = {}
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})


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
