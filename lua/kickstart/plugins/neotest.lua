-- Neotest + adapters
-- For details:
--- https://github.com/nvim-neotest/neotest
--- https://github.com/nvim-neotest/neotest-python

return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'antoinemadec/FixCursorHold.nvim',
      -- Adapter repositories
      'nvim-neotest/neotest-python',
      'alfaix/neotest-gtest',
      'nvim-treesitter/nvim-treesitter', -- Ensure treesitter is available before neotest-gtest is setup
    },
    init = function()
      local neotest = require 'neotest'

      neotest.setup {
        adapters = {
          require 'neotest-python' {
            -- pytest_discover_instances = true,  -- Very slow discovery
          },
          require('neotest-gtest').setup {},
        },
      }

      local function map(mode, l, r, opts)
        opts = opts or {}
        vim.keymap.set(mode, l, r, opts)
      end

      -- local M = {}
      -- M.enabled = false
      -- function M.toggle_panels()
      --   M.enabled = not M.enabled
      --   if M.enabled then
      --     print('Panels opened' .. tostring(M.enabled))
      --   else
      --     print('Panels closed' .. tostring(M.enabled))
      --   end
      -- end
      -- local panel_toggle = M.toggle_panels
      -- local function make_panel_toggle()
      --   local enabled = false
      --   -- vim.o.neotest_toggle_panels = false
      --   -- local toggle_panels = function()
      --   return function()
      --     -- vim.o.neotest_toggle_panels = not vim.o.neotest_toggle_panels
      --     -- if vim.o.neotest_toggle_panels then
      --     enabled = not enabled
      --     if enabled then
      --       print('Panels opened' .. tostring(enabled))
      --       neotest.output_panel.open()
      --       neotest.summary.open()
      --     else
      --       print('Panels closed' .. tostring(enabled))
      --       neotest.output_panel.close()
      --       neotest.summary.close()
      --     end
      --     -- neotest.output_panel.toggle()
      --     -- neotest.summary.toggle()
      --   end
      -- end
      -- local panel_toggle = make_panel_toggle()
      -- local function panels_toggler()
      --   -- local panels_enabled = false
      --   local panels_enabled = true
      --   return function()
      --     print(panels_enabled)
      --     panels_enabled = not panels_enabled
      --     print(panels_enabled)
      --     if panels_enabled then
      --       print 'Panels opened'
      --       neotest.output_panel.open()
      --       neotest.summary.open()
      --     else
      --       print 'Panels closed'
      --       neotest.output_panel.close()
      --       neotest.summary.close()
      --     end
      --     -- neotest.output_panel.toggle()
      --     -- neotest.summary.toggle()
      --   end
      -- end

      local toggle_panels = function()
        neotest.output_panel.toggle()
        neotest.summary.toggle()
      end

      map('n', '<leader>Tc', neotest.run.run, { desc = 'Neo[T]est: Run [S]selected test' })
      map('n', '<leader>Tp', toggle_panels, { desc = 'Neo[T]est: Show [P]anels (toggle)' })
      map('n', '<leader>Tr', neotest.run.run, { desc = 'Neo[T]est: [R]un selected test' })
      map('n', '<leader>Tw', neotest.watch.toggle, { desc = 'Neo[T]est: [W]atch selected test (toggle)' })
      map('n', '<leader>TW', neotest.watch.stop, { desc = 'Neo[T]est: Stop [W]atching test' })
    end,

    -- config = function()
    --   local neotest = require 'neotest'
    --   local config = neotest.setup {}
    --   -- config.on_attach = function(bufnr)
    --   --   local function map(mode, l, r, opts)
    --   --     opts = opts or {}
    --   --     opts.buffer = bufnr
    --   --     vim.keymap.set(mode, l, r, opts)
    --   --   end
    --   --   map('n', '<leader>ta', neotest.run.run(), { desc = '[T]est [A]ll' })
    --   --   map('n', '<leader>tp', neotest.output_panel.toggle(), { desc = '[T]oggle Neotest [P]anel' })
    --   -- end
    --   -- local function map(mode, l, r, opts)
    --   --   opts = opts or {}
    --   --   vim.keymap.set(mode, l, r, opts)
    --   -- end
    --   -- map('n', '<leader>ta', neotest.run.run(), { desc = '[T]est [A]ll' })
    --   -- map('n', '<leader>tp', neotest.output_panel.toggle(), { desc = '[T]oggle Neotest [P]anel' })
    --   return config
    -- end,
  },

  -- { -- code coverage
  --   'andythigpen/nvim-coverage',
  --   version = '*',
  --   config = function()
  --     require('coverage').setup {
  --       auto_reload = true,
  --     }
  --   end,
  -- },
  { -- code coverage
    'andythigpen/nvim-coverage',
    version = '*',
    -- ft = { 'python' },
    event = 'VimEnter', -- ensure 'cov.load()' is only executed when ready
    cond = function()
      -- dir = vim.fn.getcwd()
      -- return #vim.fn.glob(dir .. '/.coverage*', true, true) > 0
      -- f #vim.fn.glob(dir .. '/.coverage*', true, true) > 0
      -- Search for directory or file in this or any parent directory ('.;')
      -- local root = vim.fn.finddir('.coverage', '.;') ~= ''
      -- local file = vim.fn.findfile('.coverage', '.;') ~= ''
      -- return root or file
      return vim.fn.findfile('.coverage', '.;') ~= '' -- search file only
      -- return vim.bo.filetype == 'python' and vim.fn.findfile('.coverage', '.;') ~= '' -- does not work
    end,
    config = function()
      local cov = require 'coverage'
      cov.setup {
        auto_reload = true,
      }
      cov.load(true) -- load + enable signs (async)
      -- load coverage when ready
      -- vim.api.nvim_create_autocmd('VimEnter', {
      --   callback = function()
      --     cov.load(true) -- load + enable signs (async)
      --   end,
      -- })
    end,
  },
}
