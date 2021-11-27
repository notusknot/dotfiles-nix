-- Require
local settings = require("settings")
local opt = vim.opt

-- Lazy load everything!
-- Why Need Absolute Path????
-- In Lua require/dofile the default dirs is in lua folder
dofile("plugins.galaxyline.lua")
dofile("plugins.lsp.lua")
dofile("plugins.nvim-tree.lua")

-- Load All Settings
settings.load()
settings.loadPlugins()

for i,v in pairs(settings.config) do
    opt[i] = v
end
