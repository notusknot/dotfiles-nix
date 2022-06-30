pkgs:
let
    # Source my theme
    jabuti-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "jabuti-nvim";
        src = pkgs.fetchFromGitHub {
            owner = "jabuti-theme";
            repo = "jabuti-nvim";
            rev = "17f1b94cbf1871a89cdc264e4a8a2b3b4f7c76d2";
            sha256 = "sha256-iPjwx/rTd98LUPK1MUfqKXZhQ5NmKx/rN8RX1PIuDFA=";
        };
    };
in

{
    enable = true;
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
    plugins = with pkgs.vimPlugins; [ 
        vim-nix
        plenary-nvim
        {
            plugin = jabuti-nvim;
            config = "colorscheme jabuti";
        }
        {
            plugin = impatient-nvim;
            config = "lua require('impatient')";
        }
        {
            plugin = lualine-nvim;
            config = "lua require('lualine').setup()";
        }
        {
            plugin = telescope-nvim;
            config = "lua require('telescope').setup()";
        }
        {
            plugin = indent-blankline-nvim;
            config = "lua require('indent_blankline').setup()";
        }
        {
            plugin = nvim-treesitter;
            config = ''
            lua << EOF
            require('nvim-treesitter.configs').setup {
                ensure_installed = "nix", "rust", "c", "python", "lua", "html", "css", "javascript",
                highlight = {
                    enable = true,
                    disable = { "gdresource", "hack", "gdscript", "fusion", "glimmer", "glsl" }
                },
                ignore_install = { "gdresource", "hack", "gdscript", "fusion", "glimmer", "glsl" },
            }
            EOF
            '';
        }
    ];

    extraConfig = ''
        lua << EOF

        local o = vim.opt
        local g = vim.g

        -- Autocmds
        vim.cmd [[
        augroup CursorLine
            au!
            au VimEnter * setlocal cursorline
            au WinEnter * setlocal cursorline
            au BufWinEnter * setlocal cursorline
            au WinLeave * setlocal nocursorline
        augroup END
        ]]

        -- Keybinds
        local map = vim.api.nvim_set_keymap
        local opts = { silent = true, noremap = true }

        map("n", "<C-h>", "<C-w>h", opts)
        map("n", "<C-j>", "<C-w>j", opts)
        map("n", "<C-k>", "<C-w>k", opts)
        map("n", "<C-l>", "<C-w>l", opts)
        map('n', '<C-n>', ':Telescope live_grep <CR>', opts)
        map('n', '<C-f>', ':Telescope find_files <CR>', opts)
        map('n', 'j', 'gj', opts)
        map('n', 'k', 'gk', opts)
        map('n', ';', ':', { noremap = true } )

        g.mapleader = ' '

        -- Performance
        o.lazyredraw = true;
        o.shell = "zsh"
        o.shadafile = "NONE"

        -- Colors
        o.termguicolors = true

        -- Undo files
        o.undofile = true

        -- Indentation
        o.smartindent = true
        o.tabstop = 4
        o.shiftwidth = 4
        o.shiftround = true
        o.expandtab = true
        o.scrolloff = 3

        -- Set clipboard to use system clipboard
        o.clipboard = "unnamedplus"

        -- Use mouse
        o.mouse = "a"

        -- Nicer UI settings
        o.cursorline = true
        o.relativenumber = true
        o.number = true

        -- Get rid of annoying viminfo file
        o.viminfo = ""
        o.viminfofile = "NONE"

        -- Miscellaneous quality of life
        o.ignorecase = true
        o.ttimeoutlen = 5
        o.hidden = true
        o.shortmess = "atI"
        o.wrap = false
        o.backup = false
        o.writebackup = false
        o.errorbells = false
        o.swapfile = false
        o.showmode = false
        o.laststatus = 3
        o.pumheight = 6
        o.splitright = true
        o.splitbelow = true
        o.completeopt = "menuone,noselect"

        EOF
  '';
}

