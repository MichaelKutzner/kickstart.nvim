-- vim.pack.add { gh 'scalameta/nvim-metals' }
vim.pack.add { 'https://github.com/scalameta/nvim-metals' }

local nvim_opts = function()
  local metals_config = require('metals').bare_config()
  metals_config.settings = {
    serverVersion = '1.6.9+75-593d9a54-SNAPSHOT',
    inlayHints = {
      byNameParameters = { enable = true },
      hintsInPatternMatch = { enable = true },
      implicitArguments = { enable = true },
      implicitConversions = { enable = true },
      inferredTypes = { enable = true },
      typeParameters = { enable = true },
    },
  }
  metals_config.init_options.statusBarProvider = 'on' -- Disable status blocking bar after save
  metals_config.on_attach = function(client, bufnr)
    -- your on_attach function
  end

  return metals_config
end
local metals_config = nvim_opts()
local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'scala', 'sbt', 'java' },
  callback = function() require('metals').initialize_or_attach(metals_config) end,
  group = nvim_metals_group,
})
