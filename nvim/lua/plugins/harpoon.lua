-- ==========================================
-- Harpoon (ThePrimeagen의 파일 네비게이션)
-- ==========================================
-- 자주 쓰는 파일을 마킹해두고 번호로 즉시 점프
-- bufferline/탭 바 대신 사용하는 미니멀한 방식

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    local map = vim.keymap.set

    -- 현재 파일을 Harpoon 리스트에 추가
    map("n", "<leader>a", function() harpoon:list():add() end,
      { desc = "Harpoon: add file" })

    -- Harpoon 메뉴 열기 (마킹된 파일 목록 확인/편집)
    map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Harpoon: toggle menu" })

    -- 마킹된 파일로 번호 점프 (Alt+1~4)
    -- 숫자키 위치 = harpoon 번호. 한 손가락, 거의 안 보고 누름.
    map("n", "<M-1>", function() harpoon:list():select(1) end,
      { desc = "Harpoon: file 1" })
    map("n", "<M-2>", function() harpoon:list():select(2) end,
      { desc = "Harpoon: file 2" })
    map("n", "<M-3>", function() harpoon:list():select(3) end,
      { desc = "Harpoon: file 3" })
    map("n", "<M-4>", function() harpoon:list():select(4) end,
      { desc = "Harpoon: file 4" })

    -- 이전/다음 마킹 파일로 순환 이동 (Alt+P / Alt+N)
    -- 주의: 기존 <S-h>/<S-l> 은 Vim 기본 H/L(화면 위/아래 점프)을 덮어써서 교체함
    map("n", "<M-p>", function() harpoon:list():prev() end,
      { desc = "Harpoon: prev file" })
    map("n", "<M-n>", function() harpoon:list():next() end,
      { desc = "Harpoon: next file" })
  end,
}
