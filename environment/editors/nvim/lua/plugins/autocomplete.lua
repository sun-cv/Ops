


return {
    'hrsh7th/nvim-cmp',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',    -- LSP completions
        'hrsh7th/cmp-buffer',       -- buffer word completions
        'hrsh7th/cmp-path',         -- file path completions
        'L3MON4D3/LuaSnip',         -- snippet engine
        'saadparwaiz1/cmp_luasnip', -- snippet completions
    },
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
			    window = {
        			documentation = cmp.config.disable,
    		},
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>']      = cmp.mapping.confirm({ select = true }),
                ['<Tab>']     = cmp.mapping.select_next_item(),
                ['<S-Tab>']   = cmp.mapping.select_prev_item(),
                ['<C-e>']     = cmp.mapping.abort(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
            }),
        })
    end
}
