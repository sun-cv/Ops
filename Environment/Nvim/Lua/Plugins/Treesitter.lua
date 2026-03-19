


return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
        ensure_installed = { 'c_sharp', 'javascript', 'typescript', 'lua', 'json', 'html', 'css' },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    },
}
