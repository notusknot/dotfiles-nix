local g = vim.g

g.nvim_tree_side = "left"
g.nvim_tree_width = 25
g.nvim_tree_ignore = {".git", "node_modules", ".cache"}
g.nvim_tree_auto_open = 0
g.nvim_tree_auto_close = 1
g.nvim_tree_quit_on_open = 1
g.nvim_tree_follow = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_hide_dotfiles = 0
g.nvim_tree_hijack_netrw = 1
g.nvim_tree_group_empty = 1
g.nvim_tree_lsp_diagnostics = 1
g.nvim_tree_disable_window_picker = 1
g.nvim_tree_git_hl = 0
g.nvim_tree_root_folder_modifier = ":~"
g.nvim_tree_tab_open = 0
g.nvim_tree_allow_resize = 0

g.nvim_tree_show_icons = {
    git = 0,
    folders = 1,
    files = 1
}

g.nvim_tree_icons = {
    default = "",
    symlink = "",
    lsp = {
        hint = "",
        info = "",
        warning = "",
        error = "",
    }
}
