-- ==========================================
-- Undotree (실행 취소 히스토리 시각화)
-- ==========================================
-- ThePrimeagen 필수 플러그인
-- undo를 트리 형태로 보여줘서 이전 상태로 정확하게 돌아갈 수 있음

return {
  "mbbill/undotree",
  keys = {
    { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
  },
}
