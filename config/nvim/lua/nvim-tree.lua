local g = vim.g

g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
g.nvim_tree_git_hl = 0
g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_indent_markers = 1
g.nvim_tree_root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" }

require'nvim-tree'.setup {
    disable_netrw       = true,
    hijack_netrw        = true,
    open_on_setup       = false,
    ignore_ft_on_setup  = {},

    update_to_buf_dir   = {
        enable = true,
        auto_open = true,
    },

    auto_close          = true,
    open_on_tab         = false,
    hijack_cursor       = false,
    update_cwd          = false,
    diagnostics         = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        }
    },
    update_focused_file = {
        enable      = false,
        update_cwd  = false,
        ignore_list = {}
    },
    system_open = {
    cmd  = nil,
    args = {}
    },
    view = {
        width = 25,
        side = 'left',
        auto_resize = true,
        hide_root_folder = true,
        mappings = {
            custom_only = false,
            list = {}
        }
    }
}

require'nvim-tree'.setup = {
   filters = {
      dotfiles = false,
   },
   open_on_tab = false,
   hijack_cursor = true,
   hijack_unnamed_buffer_when_opening = false,
   update_cwd = true,
   update_focused_file = {
      enable = true,
      update_cwd = false,
   },
   view = {
      allow_resize = true,
      side = "left",
      width = 25,
      hide_root_folder = true,
   },
   git = {
      enable = false,
      ignore = false,
   },
   actions = {
      open_file = {
         resize_window = true,
      },
   },
}
