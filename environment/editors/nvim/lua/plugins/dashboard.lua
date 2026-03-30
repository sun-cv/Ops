


return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")

        local module = require("data.graphics.frames")

        vim.api.nvim_set_hl(0, "AlphaHeader",  { fg = "#ffb454" })
        vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#45cde0" })
        vim.api.nvim_set_hl(0, "AlphaFooter",  { fg = "#c47a1e" })

        vim.api.nvim_create_autocmd("User", {
            pattern = "AlphaReady",
            callback = function()
                vim.api.nvim_set_hl(0, "AlphaHeader",  { fg = "#ffb454" })
                vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#45cde0" })
                vim.api.nvim_set_hl(0, "AlphaFooter",  { fg = "#c47a1e" })
                vim.opt_local.cursorline   = false
                vim.opt_local.cursorcolumn = false
                vim.schedule(function()
                    vim.api.nvim_win_set_cursor(0, { 1, 0 })
                end)
            end,
        })

        local header = {
            type = "text",
            val  = module.frames[1],
            opts = { hl = "AlphaHeader", position = "center" },
        }

        local function button(key, icon, label, action)
            return {
                type = "button",
                val  = icon .. "  " .. label,
                on_press = function() vim.cmd(action) end,
                opts = {
                    position       = "center",
                    shortcut       = key,
                    cursor         = 3,
                    width          = 40,
                    align_shortcut = "right",
                    hl             = "AlphaButtons",
                    hl_shortcut    = "AlphaFooter",
                    keymap         = { "n", key, "<cmd>" .. action .. "<cr>", { noremap = true, silent = true } },
                },
            }
        end

        local buttons = {
            type = "group",
            val  = {
                { type = "padding", val = 1 },
                button("f", "󰈞", "Find File",    "Telescope find_files"),
                { type = "padding", val = 1 },
                button("r", "󰋚", "Recent Files", "Telescope oldfiles"),
                { type = "padding", val = 1 },
                button("c", "󰒓", "Config",       "e $MYVIMRC"),
                { type = "padding", val = 1 },
                button("q", "󰅙", "Quit",         "qa"),
            },
        }
        local footer = {
            type = "text",
            val  = "~ sun ~",
            opts = { hl = "AlphaFooter", position = "center" },
        }
        local layout = {
            { type = "padding", val = 4 },
            header,
            { type = "padding", val = 4 },
            buttons,
            { type = "padding", val = 2 },
            footer,
        }

        alpha.setup({ layout = layout })

        -- Animation: cycle frames every 100ms when on the dashboard
        local frame_index = 1
        local timer = vim.loop.new_timer()
        timer:start(0, 100, vim.schedule_wrap(function()
            frame_index = (frame_index % #module.frames) + 1
            local buf = vim.api.nvim_get_current_buf()
            if vim.bo[buf].filetype == "alpha" then
                header.val = module.frames[frame_index]
                alpha.redraw()
            end
        end))
    end,
}
