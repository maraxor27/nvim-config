function map(tbl, f)
    local t = {}
    for k,v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

function torque_on_init(client, bufnr)
  local cwDir = vim.fn.getcwd()
  -- print("Current working directory: " .. cwDir)
  local torque_files
  if string.find(cwDir, "/v8([0-9%.%-])*$") == nil then
    -- print("torque lsp detected V8 repo")
    torque_files = vim.split(vim.fn.glob("src/{builtins,debug,ic,objects}/*.tq"), '\n', {trimempty=true})
  elseif string.find(cwDir, "/(chrome|chromium)([0-9%.%-])*/src$") == nil then
    torque_files = vim.split(vim.fn.glob("v8/src/{builtins,debug,ic,objects}/*.tq"), '\n', {trimempty=true})
  else
    print("Couldn't figure out project path: " .. cwDir)
  end
  torque_files = map(torque_files, function(file)
    return "file://" .. cwDir .. "/" .. file
  end)
  -- vim.print(vim.tbl_values(torque_files)) 
  client:request('torque/fileList', { files = torque_files })
end

local clangd_progress = ''
local file_status = ''

return {
  "dundalek/lazy-lsp.nvim",
  dependencies = { 
    "neovim/nvim-lspconfig",
    "nvim-lualine/lualine.nvim"
  },
  config = function()
    require('lualine').setup({
      sections = {
        lualine_c = {
          { function()
            if clangd_progress ~= '' and file_status ~= '' then
              return clangd_progress .. ' | ' .. file_status
            elseif clangd_progress ~= '' then
              return clangd_progress
            end
            return file_status
          end },
        }
      }
    })


    vim.lsp.config('lua_ls', {
     on_init = function(client)
       if client.workspace_folders then
         local path = client.workspace_folders[1].name
         if
           path ~= vim.fn.stdpath('config')
           and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
         then
           return
         end
       end

       client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
         runtime = {
           -- Tell the language server which version of Lua you're using (most
           -- likely LuaJIT in the case of Neovim)
           version = 'LuaJIT',
           -- Tell the language server how to find Lua modules same way as Neovim
           -- (see `:h lua-module-load`)
           path = {
             'lua/?.lua',
             'lua/?/init.lua',
           },
         },
         -- Make the server aware of Neovim runtime files
         workspace = {
           checkThirdParty = false,
           library = {
             vim.env.VIMRUNTIME,
             -- Depending on the usage, you might want to add additional paths
             -- here.
             -- '${3rd}/luv/library',
             -- '${3rd}/busted/library',
           },
           -- Or pull in all of 'runtimepath'.
           -- NOTE: this is a lot slower and will cause issues when working on
           -- your own configuration.
           -- See https://github.com/neovim/nvim-lspconfig/issues/3189
           -- library = vim.api.nvim_get_runtime_file('', true),
         },
       })
     end,
     settings = {
       Lua = {},
     },
   })

    vim.lsp.config('clangd', {
      cmd = { '/opt/homebrew/opt/llvm/bin/clangd', '--background-index', '--clang-tidy' },
      init_options = { clangdFileStatus = true, progress = true, },
      handlers = {
        ['textDocument/clangd.fileStatus'] = function(_, result, ctx)
          file_status = result.state or ''
        end,
        ['$/progress'] = function(_, result, ctx)
          if result.token == "backgroundIndexProgress" then
            local value = result.value
            if value.kind == 'begin' then
              clangd_progress = value.title or 'indexing...'
            elseif value.kind == 'report' then
              clangd_progress = 'indexing ' .. value.message .. ' files' or clangd_progress
            elseif value.kind == 'end' then
              clangd_progress = ''
            end
          end
        end,
      },
    })

    vim.lsp.config('torque_ls', {
      cmd = { vim.fn.getcwd() .. '/out/release/torque-language-server', '-l', '/tmp/torque-language-server.log' },
      filetypes = { 'torque', },
      root_markers = {
        '.git',
      },
      on_init = torque_on_init,
      handlers = {
        ['torque/fileList'] = function(_, result, ctx)
          print('torque/fileList handler')
        end,
        ['client/registerCapability'] = function(_, result, ctx)
          return {
            result=true
          }
        end,
      }
    })
    local util = require("lspconfig.util")
    vim.lsp.config('sourcekit', { 
      root_dir = function(fname) 
        -- Block SourceKit in this directory
        local no_source_kit_paths = { "v8/", "chromimu/", "linux" }
        for _, path in pairs(no_source_kit_paths) do
          if util.path.is_descendant(fname, path) then 
            return nil
          end
        end
        return util.root_pattern("Package.swift", ".git")(fname) end, })

    vim.diagnostic.enable = true

    -- bind grd to goto definition
    vim.keymap.set('n', 'grd', function()
      vim.lsp.buf.definition()
    end)

    -- lua 
    vim.lsp.enable('lua_ls')
    -- c, c++
    vim.lsp.enable('clangd')
    -- v8 torque
    vim.lsp.enable('torque_ls')
    -- python
    vim.lsp.enable('pylsp')
    -- swift
    vim.lsp.enable('sourcekit')
    -- rust
    vim.lsp.enable('rust_analyzer')
  end,
}
