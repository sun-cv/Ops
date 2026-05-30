


return {
    'folke/noice.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
        {
            'rcarriga/nvim-notify',
            config = function()
                require('notify').setup({
                    background_colour = '#0a0e14',
                })
            end,
        },
    },
    config = function()
        require('noice').setup({
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
                signature = {
                    enabled = false,
                },
                hover = {
                    enabled = false,
                },
                progress =
                {
                    enabled = false,
                }
            },
            notify = {
                enabled = false,
            },
            messages = {
                enabled = false,
            },
            cmdline = {
                format = {
                    cmdline     = { icon_hl_group = "NoiceCmdlineIcon" },
                    search_down = { icon_hl_group = "NoiceCmdlineIcon", view = "cmdline_popup" },
                    search_up   = { icon_hl_group = "NoiceCmdlineIcon", view = "cmdline_popup" },
                },
            },
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
            },
            views = {
                cmdline_popup = {
                    position    = { row = "25%", col = "50%" },
                    size        = { width = 60, height = "auto" },
                    border      = { style = "rounded", padding = { 0, 1 } },
                    win_options = { winhighlight = "Normal:Normal,FloatBorder:DiagnosticInfo" },
                    },
                },
            })
        end
    }

