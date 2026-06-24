-- ==========================================
-- Telescope (파일 탐색기)
-- ==========================================

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  cmd = "Telescope",  -- :Telescope 명령 시 로드
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", desc = "Find files" },
    { "<leader>fg", desc = "Git files" },
    { "<leader>fb", desc = "Find buffers" },
    { "<leader>fh", desc = "Help tags" },
  },
  config = function()
    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Git files" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
  end,
}
