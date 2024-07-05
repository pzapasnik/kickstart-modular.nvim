local cmp = require('cmp')
cmp.setup {
	sources = {
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'buffer' },
		{ name = 'path' },
		{ name = 'luasnip' },
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lua' },
	}
}
