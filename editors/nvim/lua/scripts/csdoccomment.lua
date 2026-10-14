


vim.api.nvim_create_autocmd("TextChangedI", {
    pattern  = "*.cs",
    callback = function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local line = vim.api.nvim_get_current_line()
        if line:sub(1, col):match("^%s*///$") and line:sub(col + 1) == "" then
            vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { " <summary></summary>" })
            vim.api.nvim_win_set_cursor(0, { row, col + #" <summary>" })
        end
    end,
})
