local opt = vim.opt
local g = vim.g

vim.defer_fn(function()

vim.cmd [[
    syntax on
    filetype on
    colorscheme jabuti 
    
    packadd bufferline.nvim	
    packadd lualine.nvim
    packadd indent-blankline.nvim
]]

vim.defer_fn(function()

-- Enable plugins
vim.cmd [[ 
    packadd bufferline.nvim
    packadd pears.nvim
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
]]

dofile("/home/notus/.config/nixos/config/nvim/lua/statusline.lua")
dofile("/home/notus/.config/nixos/config/nvim/lua/lsp.lua")
dofile("/home/notus/.config/nixos/config/nvim/lua/nvim-tree.lua")
dofile("/home/notus/.config/nixos/config/nvim/lua/telescope.lua")

vim.cmd [[
    filetype plugin indent off 

    au FileType markdown setlocal wrap linebreak spell
    au BufWinEnter NvimTree setlocal nonumber

    nnoremap j gj
    nnoremap k gk
    map ; :

    augroup cmdline
        autocmd!
        autocmd CmdlineLeave : echo ''
    augroup end
]]

-- Disable statusline for NvimTrew
vim.api.nvim_exec(
    [[ au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif ]], false
)
--[[
require("toggleterm").setup ({
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_terminals = true,
    shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = true,
    direction =  'horizontal',
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
})
--]]
require("toggleterm").setup{
    open_mapping = [[<c-\>]],
    shade_terminals = false,
    direction = 'horizontal',
    close_on_exit = true,
    shell = vim.o.shell,
}
require('bufferline').setup({
	options = {
		offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
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
		end,
	},
    highlights = {
     	background = {					-- inactive tab color
     		guibg = "#252632",
     		guifg = "#9699b7",
     	},
     	buffer_selected = {				-- active tab color
     		guibg = "#292A37",
     		guifg = "#d9e0ee",
     		gui = "bold"
     	},
     	fill = {						-- bufferline's background color
     		guibg = "#252632",
     		guifg = "#9699b7",
     	},
     	close_button = {
            guifg = "#9699b7",
     		guibg = "#252632"
     	},
        close_button_selected = {
            guifg = "#9699b7",
     		guibg = "#292A37"
        },
     	separator = {						-- separator color. first one is the thin line; second one is the thick one
     		guifg = "#252632",
     		guibg = "#252632"
     	},
     	indicator_selected = {				-- separator when tab is active color
     		guifg = "#b072d1",
     		guibg = "#292A37"
     	},
     }
})

require('pears').setup()
require('colorizer').setup()

-- Treesitter settings
require'nvim-treesitter.configs'.setup {
    ensure_installed = "nix", "rust", "c", "python", "lua", "html", "css", "js", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true
    },
}

local map = vim.api.nvim_set_keymap
options = { noremap = true }
map('n', '<C-p>', ':NvimTreeToggle <CR>', options)
map('n', '<C-n>', ':Telescope live_grep <CR>', options)
map('n', '<C-o>', ':TZAtaraxis <CR>', options)
map('n', '<C-m>', ':TZMinimalist <CR>', options)
map('n', '<C-l>', ':noh <CR>', options)

g.mapleader = ' '

-- Indent line
g.indent_blankline_char = '▏'

-- Performance
opt.lazyredraw = true;
opt.shell = "zsh"
opt.shadafile = "NONE"

-- Colors
opt.termguicolors = true

-- Undo files
opt.undofile = true

-- Indentation
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.expandtab = true
opt.scrolloff = 3

-- Set clipboard to use system clipboard
opt.clipboard = "unnamedplus"

-- Use mouse
opt.mouse = "a"

-- Nicer UI settings
opt.cursorline = true
opt.relativenumber = true
opt.number = true

-- Get rid of annoying viminfo file
opt.viminfo = ""
opt.viminfofile = "NONE"

-- Miscellaneous quality of life
opt.ignorecase = true
opt.ttimeoutlen = 5
opt.hidden = true
opt.shortmess = "atI"
opt.wrap = false
opt.backup = false
opt.writebackup = false
opt.errorbells = false
opt.swapfile = false
opt.showmode = false

end, 15)
end, 0)
