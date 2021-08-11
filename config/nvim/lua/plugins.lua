-- Enable plugins
require('bufferline').setup()
require('pears').setup()
require('colorizer').setup()

-- Neorg settings
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
    install_info = {
        url = "https://github.com/vhyrro/tree-sitter-norg",
        files = { "src/parser.c" },
        branch = "main"
    },
}
-- Treesitter settings 
require'nvim-treesitter.configs'.setup {
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,              -- false will disable the whole extension
    },
    autotag = {
        enable = true,
    },
}

require('neorg').setup {
    -- Tell Neorg what modules to load
    load = {
        ["core.defaults"] = {}, -- Load all the default modules
        ["core.highlights"] = {}, -- Allows for use of icons
        ["core.keybinds"] = {
            config = {
                default_keybinds = true
            }},
        ["core.norg.concealer"] = {
            config = {
                icons = {
                    heading = {
                            enabled = true, -- Enable beautified headings

                            -- Define icons for all the different heading levels
                            level_3 = {
                            enabled = true,
                            icon = "",
                        },
                    },
                }
            }
        },
    },
}
