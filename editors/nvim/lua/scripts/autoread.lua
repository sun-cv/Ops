
vim.opt.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "WinEnter" }, {
    pattern = "*",
    callback = function()
        vim.cmd("checktime")
    end,
    desc = "Reload buffer when file changes on disk",
})

--vim.api.nvim_create_autocmd({ "TabClosed", "TabLeave" }, {
--    pattern = "*",
--   callback = function()
--        vim.schedule(function()
--            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
--                if vim.api.nvim_buf_is_loaded(bufnr) then
--                   vim.cmd("checktime " .. bufnr)
--                end
--            end
--        end)
--   end,
--    desc = "Reload all buffers after diff tab is accepted",
--})
