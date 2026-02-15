return {
    {
        "jpalardy/vim-slime",
        init = function()
            vim.g.slime_no_mappings = -1
        end
    },

    {
        'klafyvel/vim-slime-cells',
        ft = { 'python' },
        config = function()
            vim.g.slime_target = "tmux"
            vim.g.slime_cell_delimiter = "# %%"
            vim.g.slime_default_config = { socket_name = "default", target_pane = "0" }
            vim.g.slime_dont_ask_default = 1
            vim.g.slime_bracketed_paste = 1
            vim.g.slime_no_mappings = 1
            vim.cmd([[
    nmap <leader>cv <Plug>SlimeConfig
    nmap <leader>cc <Plug>SlimeCellsSendAndGoToNext
    nmap <leader>cl <Plug>SlimeLineSend
    nmap <leader>cj <Plug>SlimeCellsNext
    nmap <leader>ck <Plug>SlimeCellsPrev
    map <leader><cr> <Plug>SlimeSendCell
    vmap <leader>cc :SlimeSend<cr>
    ]])
        end
    },
}
