


return {
    'romgrk/barbar.nvim',
    dependencies = {
        'lewis6991/gitsigns.nvim',
        'nvim-tree/nvim-web-devicons'
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
        animation           = true,
        tabpages            = true,
        highlight_visible   = true,
        highlight_alternate = false,
        icons =
        {
            separator           = { left = '▌', right = ''},
        },
        insert_at_end       = true,
        maximum_length      = 5,
        minimum_padding     = 1,
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
}


