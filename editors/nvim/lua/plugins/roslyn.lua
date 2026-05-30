


vim.lsp.config("roslyn", {
  settings = {
    ["csharp|background_analysis"] = {
      dotnet_analyzer_diagnostics_scope = "openFiles",
      dotnet_compiler_diagnostics_scope = "openFiles",
    },
  },
})

return {
  "seblyng/roslyn.nvim",
  ft = "cs",
  opts = {
    filewatching = "roslyn",
  },
}
