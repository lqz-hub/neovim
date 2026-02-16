return {
  "jupyter-vim/jupyter-vim",
  init = function()
    vim.g.jupyter_mapkeys = 0
  end,
  config = function()
    -- 使用 <cmd> 和 <CR> 执行两个命令
    vim.keymap.set(
      "n",
      "<leader>x",
      "<cmd>JupyterSendCell<CR><cmd>normal ]h<CR>",
      { desc = "Send cell and go to next" }
    )
    vim.keymap.set("n", "<leader>X", "<cmd>JupyterSendCell<CR>", { desc = "Send cell" })
  end,
}
