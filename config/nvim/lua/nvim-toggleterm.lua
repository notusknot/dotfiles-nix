require("toggleterm").setup{
    open_mapping = [[<c-\>]],
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = 'curved',
        width = 155,
        height = 60,
    }
}
