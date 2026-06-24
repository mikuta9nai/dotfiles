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

    -- 마킹된 파일로 번호 점프 (1~4)
    map("n", "<C-h>", function() harpoon:list():select(1) end,
      { desc = "Harpoon: file 1" })
    map("n", "<C-t>", function() harpoon:list():select(2) end,
      { desc = "Harpoon: file 2" })
    map("n", "<C-n>", function() harpoon:list():select(3) end,
      { desc = "Harpoon: file 3" })
    map("n", "<C-s>", function() harpoon:list():select(4) end,
      { desc = "Harpoon: file 4" })

    -- 이전/다음 마킹 파일로 순환 이동
    map("n", "<S-h>", function() harpoon:list():prev() end,
      { desc = "Harpoon: prev file" })
    map("n", "<S-l>", function() harpoon:list():next() end,
      { desc = "Harpoon: next file" })
  end,
}
