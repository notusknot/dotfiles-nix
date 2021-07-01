-- This file configures nvim-tree.lua, a fast file tree plugin
-- Special thanks to https://github.com/siduck76/NvChad for the inspiration

local M = {}

M.config = function()
    local g = vim.g

    g.nvim_tree_side = "right"
    g.nvim_tree_width = 25
    g.nvim_tree_ignore = {".git", "node_modules", ".cache"}
    g.nvim_tree_auto_open = 1
    g.nvim_tree_auto_close = 1
    g.nvim_tree_quit_on_open = 1
    g.nvim_tree_follow = 1
    g.nvim_tree_indent_markers = 1
    g.nvim_tree_hide_dotfiles = 0
    g.nvim_tree_hijack_netrw = 1
    g.nvim_tree_group_empty = 1
    g.nvim_tree_lsp_diagnostics = 1
    g.nvim_tree_disable_window_picker = 1
    g.nvim_tree_git_hl = 1
    g.nvim_tree_root_folder_modifier = ":~"
    g.nvim_tree_tab_open = 0
    g.nvim_tree_allow_resize = 0

    g.nvim_tree_show_icons = {
        git = 1,
        folders = 1,
        files = 1
    }

    g.nvim_tree_icons = {
        default = "",
        symlink = "",
        git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌"
        },
        folder = {
            default = "",
            open = "",
            symlink = "",
            empty = "",
            empty_open = "",
            symlink_open = ""
        },
        lsp = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        }
    }

    local tree_cb = require "nvim-tree.config".nvim_tree_callback
    g.nvim_tree_bindings = {
        ["u"] = ":lua require'some_module'.some_function()<cr>",
        -- default mappings
        ["<CR>"] = tree_cb("tabnnew"),
    }
end

return M
