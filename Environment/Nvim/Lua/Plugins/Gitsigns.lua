

return {
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup({
                signs = {
                    add          = { text = '+' },
                    change       = { text = '~' },
                    delete       = { text = '-' },
                    topdelete    = { text = '-' },
                    changedelete = { text = '~' },
                },
                current_line_blame = false,
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local opts = { buffer = bufnr }
                    vim.keymap.set('n', ']h', gs.next_hunk, opts)
                    vim.keymap.set('n', '[h', gs.prev_hunk, opts)
                    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, opts)
                    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, opts)
                    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, opts)
                    vim.keymap.set('n', '<leader>hb', gs.blame_line, opts)
                end
            })
        end
    },
}
