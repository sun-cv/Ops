local oil       = require("oil")
local module    = {}


local CloseAllBuffers = function()
    for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
        if buf.changed == 1 and buf.name ~= "" then
            vim.api.nvim_buf_call(buf.bufnr, function()
                vim.cmd("silent! write")
            end)
        end
    end
    for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
        local ok, err = pcall(vim.api.nvim_buf_delete, buf.bufnr, { force = buf.name == "" })
        if not ok then
            vim.notify("Could not close buffer " .. buf.bufnr .. ": " .. err, vim.log.levels.WARN)
        end
    end
    vim.cmd("Alpha")
end

local TerminalToDirectory = function()
    for _, term in ipairs(
        require("toggleterm.terminal").get_all())
        do term:send("cd " .. require("oil").get_current_dir())
        end
    end


local OpenFileTree =  function()
    if oil.get_current_dir() then
        oil.discard_all_changes()
        require("oil.actions").parent.callback()
    else
        oil.discard_all_changes()
        oil.open_float(nil, { preview = { vertical = true } })
    end
end

module.CloseAllBuffers      = CloseAllBuffers
module.OpenFileTree         = OpenFileTree
module.TerminalToDirectory  = TerminalToDirectory


return module
