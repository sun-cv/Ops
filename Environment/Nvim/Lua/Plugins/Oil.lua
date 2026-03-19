


return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('oil').setup({
            default_file_explorer = true,
            columns = {
                { "icon", align = "center" }
            },
            keymaps = {
                ["<Esc>"] = "actions.close",
            },
            float = {
                border = "none",
                preview_split = "right",
                override = function(conf)
                    conf.border = "none"
                    return conf
                end,
            },
            view_options = {
                show_hidden = false,
                is_hidden_file = function(name, bufnr)
                    return vim.startswith(name, '.')
                end,
                is_always_hidden = function(name, bufnr)
                    return name == 'meta' or vim.endswith(name, '.meta')
                end,
                is_always_hidden = function(name, bufnr)
                    return name == 'meta' or vim.endswith(name, '.meta') or name == 'Documents and Settings'
                end,
            },
            skip_confirm_for_simple_edits = true,
            prompt_save_on_select_new_entry = true,
            delete_to_trash = true,
            preview_win = {
                win_options = {
                    wrap = false,
                    signcolumn = "no",
                    cursorcolumn = false,
                    foldcolumn = "0",
                    spell = false,
                    list = false,
                    conceallevel = 3,
                    concealcursor = "nvic",
                },
            },
        })
    end
}
