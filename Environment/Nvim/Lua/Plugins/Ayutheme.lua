


return {
    'Shatur/neovim-ayu',
    config = function()
        require('ayu').setup({
            mirage 							= false,
            overrides = {
                Normal 						= { bg = 'None' 					},
                NormalNC 					= { bg = 'None' 					},
                SignColumn 					= { bg = 'None' 					},
                LineNr 						= { fg = '#5c6773' 					},
                CursorLineNr 				= { fg = '#ffcc66' 					},
                StatusLine 					= { bg = 'None' 					},
                StatusLineNC 				= { bg = 'None' 					},
                WinSeparator 				= { bg = 'None' 					},
				MsgArea 					= { bg = '#0a0e14', fg = '#cbccc6'	},
				VM_Cursor 					= { bg = '#ffcc66', fg = '#0a0e14'	},
				VM_Extend 					= { bg = '#3d5166' 					},
				VM_Mono 					= { bg = '#ffcc66', fg = '#0a0e14' 	},
				VM_Insert 					= { bg = '#ffcc66', fg = '#0a0e14' 	},
				NoiceCmdlinePopup 			= { bg = '#141419', fg = '#e6b450' 	},
				NoiceCmdlinePopupBorder 	= { fg = '#ffb454' 					},
				NoiceCmdlineIcon 			= { fg = '#7acde4' 					},
                Search                      = { bg = '#3d5166', fg = '#cbccc6'  },
                CurSearch                   = { bg = '#ffb454', fg = '#0a0e14'  },
                IncSearch                   = { bg = '#ffcc66', fg = '#171717'  },
                CursorLine                  = { bg = 'None'                     },
                Cursor                      = { bg = '#ffffff', fg = '#171717'  },
                lCursor                     = { bg = '#ffffff', fg = '#171717'  },
                CursorIM                    = { bg = '#ffffff', fg = '#171717'  },
                BufferTabpageFill           = { bg = "None"                     },
                BufferCurrent               = { bg = "None"                 },
                BufferCurrentMod            = { bg = "None"                     },
                BufferVisible               = { bg = "None"                     },
                BufferVisibleMod            = { bg = "None"                     },
                BufferInactive              = { bg = "None"                     },
                BufferInactiveMod           = { bg = "None"                     },
                TabLine                     = { bg = "None"                     },
                TabLineFill                 = { bg = "None"                     },
                TabLineSel                  = { bg = "None"                     },
            },
        })
        require('ayu').colorscheme()
    end
}
