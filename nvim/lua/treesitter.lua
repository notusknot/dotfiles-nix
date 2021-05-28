-- This is a lua config file for the nvim-treesitter plugin
-- All it does is enable the enhanced syntax highlighting
require'nvim-treesitter.configs'.setup {
      ensure_installed = "maintained",
      highlight = {
        enable = true, 
      },
    }
