


local module    = {}
local indicator = ""

vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function()
        indicator = "  "
        vim.defer_fn(function()
            indicator = ""
            require("lualine").refresh()
        end, 1000)
    end
})

module.component = function()
    return indicator
end

return module

