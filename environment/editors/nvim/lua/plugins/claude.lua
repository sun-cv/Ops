


return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal_cmd = "C:\\Users\\Sun\\.local\\bin\\claude.exe",
    diff_opts = {
      open_in_new_tab = true,
      hide_terminal_in_new_tab = true,
    },
    terminal = {
      provider = "snacks",
      snacks_win_opts = {
        position = "float",
        width = 0.25,
        height = .99,
        row = 0,
        col = -1,
        border = "rounded",
        wo = {
          winhighlight = "NormalFloat:ClaudeFloat,FloatBorder:ClaudeFloatBorder",
        },
      },
    },
  },
}
