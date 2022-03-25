vim.cmd [[
    packadd bufferline.nvim
    packadd nvim-autopairs
    packadd nvim-tree.lua
    packadd nvim-web-devicons
    packadd TrueZen.nvim
    packadd telescope.nvim
    packadd nvim-colorizer.lua
    packadd vim-nix
    packadd toggleterm.nvim
    packadd cmp-buffer
    packadd cmp-nvim-lsp
    packadd cmp-path
    packadd nvim-cmp
    packadd bufferline.nvim	
    packadd lualine.nvim
    packadd nvim-lspconfig
    packadd nvim-treesitter
    packadd indent-blankline.nvim

]]

-- Colorize hex codes and autocmplete pairs
require('nvim-autopairs').setup()
require('colorizer').setup()

-- Toggleable terminal
require("toggleterm").setup {
    open_mapping = [[<c-\>]],
    shade_terminals = false,
    direction = 'horizontal',
    close_on_exit = true,
    size = 25,
    shell = vim.o.shell
}

-- Fancy bufferline
require('bufferline').setup {
    options = {
        offsets = {{filetype = "NvimTree", text = "", padding = 1}},
        separator_style = "thin",
        custom_filter = function(buf_number)
            local present_type, type = pcall(function()
                return vim.api.nvim_buf_get_var(buf_number, "term_type")
            end)

            if present_type then
                if type == "vert" then
                    return false
                elseif type == "hori" then
                    return false
                end
                return true
            end

            return true
        end
    },
    highlights = {
        background = { -- inactive tab color
            guibg = "#252632",
            guifg = "#9699b7"
        },
        buffer_selected = { -- active tab color
            guibg = "#292A37",
            guifg = "#d9e0ee",
            gui = "bold"
        },
        fill = { -- bufferline's background color
            guibg = "#252632",
            guifg = "#9699b7"
        },
        close_button = {guifg = "#9699b7", guibg = "#252632"},
        close_button_selected = {guifg = "#9699b7", guibg = "#292A37"},
        separator = { -- separator color. first one is the thin line; second one is the thick one
            guifg = "#252632",
            guibg = "#252632"
        },
        indicator_selected = { -- separator when tab is active color
            guifg = "#b072d1",
            guibg = "#292A37"
        }
    }
}

-- Better syntax highlighting
require'nvim-treesitter.configs'.setup {
    ensure_installed = "nix", "rust", "c", "python", "lua", "html", "css", "javascript", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,
        disable = { "gdresource", "hack", "gdscript", "fusion", "glimmer", "glsl" }
    },
    ignore_install = { "gdresource", "hack", "gdscript", "fusion", "glimmer", "glsl" },
}

-- Language servers for better integration
require'lspconfig'.rnix.setup {}
require'lspconfig'.sumneko_lua.setup {}
require'lspconfig'.rust_analyzer.setup {}

local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')

-- ZK lsp (Zettelkasten)
configs.zk = {
    default_config = {
        cmd = {'zk', 'lsp'},
        filetypes = {'markdown'},
        root_dir = function() return vim.loop.cwd() end,
        settings = {}
    }
}

lspconfig.zk.setup({on_attach = function(client, buffer) end})

-- Icons for nvim-cmp
local kind_icons = {
    Text = "", Method = "", Function = "", Constructor = "", Field = "",
    Variable = "", Class = "ﴯ", Interface = "", Module = "",
    Property = "ﰠ", Unit = "", Value = "", Enum = "",
    Keyword = "", Snippet = "", Color = "", File = "",
    Reference = "", Folder = "", EnumMember = "", Constant = "",
    Struct = "", Event = "", Operator = "", TypeParameter = ""
}

-- Fancy completion
local cmp = require 'cmp'

require("cmp").setup {
    mapping = {
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
        ['<CR>'] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
        {name = 'nvim_lsp'}, {name = 'buffer'}, {name = 'path'}
    }),
    formatting = {
        format = function(entry, vim_item)

            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind

            -- Source
            vim_item.menu = ({buffer = " ", nvim_lsp = " ", path = " "})[entry.source.name]

            return vim_item
        end
    }
}

-- Sidebar file explorer
require'nvim-tree'.setup {
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {},

    update_to_buf_dir = {enable = true, auto_open = true},

    auto_close = true,
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = false,
    diagnostics = {
        enable = true,
        icons = {hint = "", info = "", warning = "", error = ""}
    },
    update_focused_file = {enable = false, update_cwd = false, ignore_list = {}},
    view = {
        width = 30,
        side = 'left',
        auto_resize = true,
        hide_root_folder = true
    }
}

-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
    blue = '#26bbd9',
    cyan = '#59e3e3',
    black = '#292a37',
    white = '#d9e0ee',
    red = '#e95678',
    violet = '#b072d1',
    grey = '#393a4d'
}

-- Fancy statusline
local bubbles_theme = {
    normal = {
        a = {fg = colors.black, bg = colors.violet},
        b = {fg = colors.white, bg = colors.grey},
        c = {fg = colors.black, bg = colors.black}
    },

    insert = {a = {fg = colors.black, bg = colors.blue}},
    visual = {a = {fg = colors.black, bg = colors.cyan}},
    replace = {a = {fg = colors.black, bg = colors.red}},

    inactive = {
        a = {fg = colors.white, bg = colors.black},
        b = {fg = colors.white, bg = colors.black},
        c = {fg = colors.black, bg = colors.black}
    }
}

require('lualine').setup {
    options = {
        theme = bubbles_theme,
        component_separators = '|',
        section_separators = {left = '', right = ''}
    },
    sections = {
        lualine_a = {{'mode', separator = {left = ''}, right_padding = 2}},
        lualine_b = {'filename', 'branch'},
        lualine_c = {'fileformat'},
        lualine_x = {},
        lualine_y = {'filetype', 'progress'},
        lualine_z = {
            {'location', separator = {right = ''}, left_padding = 2}
        }
    },
    inactive_sections = {
        lualine_a = {'filename'},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'location'}
    },
    tabline = {},
    extensions = {}
}

-- Super fast fuzzy find
require('telescope').setup {
    defaults = {
        vimgrep_arguments = {
            "rg", "--no-heading", "--with-filename", "--line-number",
            "--column", "--smart-case"
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8
            },
            vertical = {mirror = false},
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = {"node_modules"},
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = {"truncate"},
        winblend = 0,
        border = {},
        borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
        color_devicons = true,
        use_less = true,
        set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new
    }
}

