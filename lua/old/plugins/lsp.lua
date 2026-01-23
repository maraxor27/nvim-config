function map(tbl, f)
    local t = {}
    for k,v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

function torque_on_init(client, bufnr)
  local cwDir = vim.fn.getcwd()
  print("Current working directory: " .. cwDir)
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



return {
  "dundalek/lazy-lsp.nvim",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    vim.lsp.config('clangd', {
      cmd = { 'clangd', '--background-index' }
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

    vim.diagnostic.enable = true
    -- vim.diagnostic.config({
    --   virtual_lines = true,
    -- })
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
