return {
    "skywind3000/asynctasks.vim",
    dependencies = {
        "skywind3000/asyncrun.vim",
        "voldikss/vim-floaterm",
        -- "akinsho/toggleterm.nvim"
    },
    config = function()
        vim.g.asyncrun_open = 8
        vim.g.asynctasks_term_pos = 'external'
        vim.g.asyncrun_rootmarks = { '.git', '.svn', '.root', '.project', '.hg' }
        vim.keymap.set("n", "<F5>", ":AsyncTask file-run<cr>", { noremap = true, silent = true })
        vim.keymap.set("n", "<F6>", ":AsyncTask project-build<cr>", { noremap = true, silent = true })
        vim.keymap.set("n", "<F9>", ":AsyncTask file-build<cr>", { noremap = true, silent = true })
    end
}
