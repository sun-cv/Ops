


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

                -- Current (active) buffer
                BufferCurrent               = { bg = "None", fg = "#cbccc6" },
                BufferCurrentIcon           = { bg = "None", fg = "#FFB454" },
                BufferCurrentMod            = { bg = "None", fg = "#f28779" },  -- unsaved, active
                BufferCurrentModIcon        = { bg = "None", fg = "#f28779" },
                BufferCurrentBtn            = { bg = "None", fg = "#5A6378" },
                BufferCurrentSign           = { bg = "None", fg = "#ffcc66" },
                BufferCurrentTarget         = { bg = "None", fg = "#ffcc66" },  -- jump letter

                -- Visible (in split, not focused)
                BufferVisible               = { bg = "None", fg = "#cbccc6" },
                BufferVisibleIcon           = { bg = "None", fg = "#FFB454" },
                BufferVisibleMod            = { bg = "None", fg = "#5A6378" },
                BufferVisibleSign           = { bg = "None", fg = "#5A6378" },
                BufferVisibleTarget         = { bg = "None", fg = "#ffcc66" },

                -- Inactive
                BufferInactive              = { bg = "None", fg = "#5A6378" },
                BufferInactiveIcon          = { bg = "None", fg = "#5A6378" },
                BufferInactiveMod           = { bg = "None", fg = "#5A6378" },
                BufferInactiveSign          = { bg = "None", fg = "#5A6378" },
                BufferInactiveTarget        = { bg = "None", fg = "#ffcc66" },

                -- Special
                BufferTabpageFill           = { bg = "None" },
                BufferTabpages              = { bg = "None", fg = "#5A6378" },
                BufferTabpagesSep           = { bg = "None", fg = "#5A6378" },
                BufferScrollArrow           = { bg = "None", fg = "#59C2FF" },

                TabLineFill                 = { bg = "None" },
                TabLine                     = { bg = "None" },
            },
        })
        require('ayu').colorscheme()
    end
}
