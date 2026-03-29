


return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
        ensure_installed = { 'c_sharp', 'javascript', 'typescript', 'lua', 'json', 'html', 'css' },
        auto_install = true,
        highlight = {
            enable = true,
            disable = { "c_sharp" },
            additional_vim_regex_highlighting = false,
        },
        indent = { 
            enable = true,
            disable = { "c_sharp" },
        },
    }
}
