


local indicator_saved       = require("components.indicatorSave"); 
local indicator_recording   = require("components.indicatorRecording"); 


return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup({
            options = {
                theme = {
                    normal   = { a = { bg = '#59C2FF', fg = '#000000', gui = 'bold' },
                                 b = { bg = 'NONE', fg = '#5A6378' },
                                 c = { bg = 'NONE', fg = '#5A6378' } },
                    insert   = { a = { bg = '#70BF56', fg = '#000000', gui = 'bold' },
                                 b = { bg = 'NONE', fg = '#ffffff' },
                                 c = { bg = 'NONE', fg = '#ffffff' } },
                    visual   = { a = { bg = '#FFB454', fg = '#000000', gui = 'bold' },
                                 b = { bg = 'NONE', fg = '#ffffff' },
                                 c = { bg = 'NONE', fg = '#ffffff' } },
                    replace  = { a = { bg = '#F07171', fg = '#000000', gui = 'bold' },
                                 b = { bg = 'NONE', fg = '#ffffff' },
                                 c = { bg = 'NONE', fg = '#ffffff' } },
                    command  = { a = { bg = '#A37ACC', fg = '#000000', gui = 'bold' },
                                 b = { bg = 'NONE', fg = '#5A6378' },
                                 c = { bg = 'NONE', fg = '#5A6378' } },
                    inactive = { a = { bg = '#ADAEB1', fg = '#888888' },
                                 b = { bg = 'NONE', fg = '#5A6378' },
                                 c = { bg = 'NONE', fg = '#5A6378' } },
                },
                component_separators    = { left = '', right = '' },
                section_separators      = { left = '', right = '' },
                globalstatus            = true,
            },
            refresh = {
                statusline = 50,
            },
            sections = {
                lualine_a = {
                    {
                        'mode',
                        separator   = { left = '', right = '' },
                        padding     = { left = 3,   right = 2   },
                    },
                },
                lualine_b = { 'diagnostics' },
                lualine_c = {{ indicator_recording.component }},
                lualine_x = { },
                lualine_y = {{ indicator_saved.component }},
                lualine_z = {
                    {
                        'location',
                        separator = { left = '', right = '' },
                        padding = { left = 3, right = 2 },
                    },
                },
            },
        })
    end
}
