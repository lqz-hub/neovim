return {
    { "neovim/nvim-lspconfig" },
    { 'williamboman/nvim-lsp-installer' },
    {
        'dgagn/diagflow.nvim',
        -- event = 'LspAttach', This is what I use personnally and it works great
        opts = {}
    }
}
