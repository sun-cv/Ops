

return
{
	'tpope/vim-fugitive',
    cmd = 'Git',
    keys = {
    	{ '<leader>gs', '<cmd>Git<cr>',        desc = 'Git status' },
        { '<leader>gc', '<cmd>Git commit<cr>', desc = 'Git commit' },
        { '<leader>gp', '<cmd>Git push<cr>',   desc = 'Git push' },
        { '<leader>gl', '<cmd>Git log<cr>',    desc = 'Git log' },
	}
}
