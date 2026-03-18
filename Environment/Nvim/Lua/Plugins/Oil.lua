


return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('oil').setup({
            default_file_explorer = true,
            keymaps = {
                ["q"] = "actions.close",
            },
            view_options = {
                show_hidden = false,
                is_hidden_file = function(name, bufnr)
                    return vim.startswith(name, '.')
                end,
                is_always_hidden = function(name, bufnr)
                    return name == 'meta' or vim.endswith(name, '.meta')
                end,
            },
              delete_to_trash = true,
        })
    end
}
