


return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup({
            options = {
                theme = 'ayu_dark',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                globalstatus = false,
				TabLine = { bg = 'None' },
				TabLineFill = { bg = 'None' },
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = {{ 'filename', path = 2 }},
                lualine_x = { 'encoding', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' },
            },
       })
    end}
