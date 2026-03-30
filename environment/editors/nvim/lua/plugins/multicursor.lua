


return {
    'mg979/vim-visual-multi',
    config = function()
        vim.g.VM_silent_exit = 1
        vim.g.VM_quit_after_leaving_insert_mode = 0
        vim.g.VM_verbose_commands = 0
        vim.g.VM_maps = {
            ['Find Under']         = '<C-n>',
            ['Find Subword Under'] = '<C-n>',
            ['Add Cursor Down']    = '<C-j>',
            ['Add Cursor Up']      = '<C-k>',
        }
    end
}
