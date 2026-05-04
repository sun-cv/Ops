


vim.api.nvim_set_hl(0, "DashboardHeader",       { fg = "#ffb454"                      })

-- Claude float
vim.api.nvim_set_hl(0, "ClaudeFloatBorder",     { bg = "NONE", fg = "#3d5166"         })

vim.api.nvim_set_hl(0, "@lsp.type.extensionMethod.cs",  { fg = "#ffb454"              })
vim.api.nvim_set_hl(0, "@lsp.type.delegate.cs",         { fg = "#ffb454"              })

-- Diff (side-by-side)
vim.api.nvim_set_hl(0, "DiffAdd",               { fg = "#7fd962"                      })
vim.api.nvim_set_hl(0, "DiffDelete",            { fg = "#f26d78"                      })
vim.api.nvim_set_hl(0, "DiffChange",            { fg = "#59c2ff"                      })
vim.api.nvim_set_hl(0, "DiffText",              { fg = "#e6b450"                      })

-- Diff (fugitive / :Git diff)
vim.api.nvim_set_hl(0, "diffAdded",             { fg = "#7fd962"                      })
vim.api.nvim_set_hl(0, "diffRemoved",           { fg = "#f26d78"                      })
vim.api.nvim_set_hl(0, "diffLine",              { fg = "#59c2ff"                      })
vim.api.nvim_set_hl(0, "diffSubname",           { fg = "#e6b450"                      })

vim.api.nvim_set_hl(0, "Normal", 		        { bg = "NONE", ctermbg = "NONE"         })
vim.api.nvim_set_hl(0, "NormalNC", 		        { bg = "NONE", ctermbg = "NONE"         })
vim.api.nvim_set_hl(0, "NormalFloat", 	        { bg = "NONE", ctermbg = "NONE"         })
vim.api.nvim_set_hl(0, "FloatBorder", 	        { bg = "NONE", ctermbg = "NONE"         })
vim.api.nvim_set_hl(0, "SignColumn", 	        { bg = "NONE", ctermbg = "NONE"         })
vim.api.nvim_set_hl(0, "StatusLine", 	        { bg = "NONE", ctermbg = "NONE"         })
vim.api.nvim_set_hl(0, "TabLine", 		        { bg = "NONE", ctermbg = "NONE"         })
vim.api.nvim_set_hl(0, "TabLineFill", 	        { bg = "NONE", ctermbg = "NONE"         })
vim.api.nvim_set_hl(0, "TerminalNormal",        { bg = "NONE", ctermbg = "NONE"         })

-- Terminal ANSI colors (ayu dark)
vim.g.terminal_color_0  = "#0a0e14"  -- black
vim.g.terminal_color_1  = "#f28779"  -- red
vim.g.terminal_color_2  = "#c2d94c"  -- green
vim.g.terminal_color_3  = "#ffb454"  -- yellow
vim.g.terminal_color_4  = "#59c2ff"  -- blue
vim.g.terminal_color_5  = "#d2a6ff"  -- magenta
vim.g.terminal_color_6  = "#95e6cb"  -- cyan
vim.g.terminal_color_7  = "#cbccc6"  -- white
vim.g.terminal_color_8  = "#3d5166"  -- bright black
vim.g.terminal_color_9  = "#f28779"  -- bright red
vim.g.terminal_color_10 = "#c2d94c"  -- bright green
vim.g.terminal_color_11 = "#ffcc66"  -- bright yellow
vim.g.terminal_color_12 = "#59c2ff"  -- bright blue
vim.g.terminal_color_13 = "#d2a6ff"  -- bright magenta
vim.g.terminal_color_14 = "#95e6cb"  -- bright cyan
vim.g.terminal_color_15 = "#ffffff"  -- bright white
