


local module    = {}
local indicator = ""

vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
        indicator = "  " ..vim.fn.reg_recording()
    end
})

vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
        indicator = ""
    end
})


module.component = function()
    return indicator
end

return module
