-- ==========================================
-- vim-tmux-navigator (nvim split ↔ tmux pane 심리스 이동)
-- ==========================================
-- C-h/j/k/l 하나로 nvim split 과 tmux pane 을 경계 없이 넘나든다.
-- 경계가 split 이면 split 이동, nvim 가장자리를 넘으면 자동으로 tmux pane 으로.
-- tmux 쪽 짝은 ~/.tmux.conf 의 christoomey/vim-tmux-navigator 플러그인(TPM).
--
-- 주의: 이 C-j/C-k 때문에 기존 quickfix 이동은 keymaps.lua 에서 [q/]q 로 옮겼다.

return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<CR>",  desc = "Nav left (split/pane)" },
    { "<C-j>", "<cmd>TmuxNavigateDown<CR>",  desc = "Nav down (split/pane)" },
    { "<C-k>", "<cmd>TmuxNavigateUp<CR>",    desc = "Nav up (split/pane)" },
    { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Nav right (split/pane)" },
  },
}
