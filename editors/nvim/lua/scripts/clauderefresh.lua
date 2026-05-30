local timer = vim.uv.new_timer()

vim.api.nvim_create_autocmd("TermEnter", {
    callback = function()
        timer:start(0, 500, vim.schedule_wrap(function()
            vim.cmd("checktime")
            pcall(vim.api.nvim__redraw, { flush = true })
        end))
    end,
})

vim.api.nvim_create_autocmd("TermLeave", {
    callback = function()
        timer:stop()
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        timer:stop()
    end,
})