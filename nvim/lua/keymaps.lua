-- ==========================================
-- 키맵 설정 (ThePrimeagen 스타일)
-- ==========================================

local map = vim.keymap.set

-- ==========================================
-- [1] 기본 이동 개선 (ThePrimeagen 핵심 키맵)
-- ==========================================

-- 파일 탐색기 (netrw)
vim.g.netrw_keepdir = 0
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw explorer" })

-- Visual 모드에서 선택 블록 위/아래로 이동
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- J (줄 합치기) 시 커서 위치 유지
map("n", "J", "mzJ`z", { desc = "Join line (keep cursor)" })

-- 반 페이지 스크롤 시 커서 중앙 유지
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- 검색 시 커서 중앙 유지
map("n", "n", "nzzzv", { desc = "Next search (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search (centered)" })

-- ==========================================
-- [2] 복사/붙여넣기 개선
-- ==========================================

-- 붙여넣기 시 레지스터 덮어쓰지 않기 (선택 영역 위에 붙여넣을 때)
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwrite register" })

-- 시스템 클립보드로 복사 (명시적)
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- 블랙홀 레지스터로 삭제 (레지스터 오염 방지)
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void register" })

-- ==========================================
-- [3] 편의 키맵
-- ==========================================

-- 검색 하이라이트 해제
map("n", "<Esc>", ":nohlsearch<CR><Esc>", { silent = true, desc = "Clear search highlight" })

-- Q 비활성화 (실수로 Ex 모드 진입 방지)
map("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- 터미널 Esc로 Normal 모드 전환
map("t", "<Esc>", [[<C-\><C-N>]], { desc = "Terminal: exit insert mode" })

-- quickfix 리스트 이동 ([d/]d 진단과 동일한 관례).
-- C-j/C-k 는 vim-tmux-navigator 가 split/pane 이동에 쓰므로 [q/]q 로 옮김.
map("n", "]q", ":cnext<CR>zz", { desc = "Next quickfix" })
map("n", "[q", ":cprev<CR>zz", { desc = "Prev quickfix" })

-- 현재 단어 전체 바꾸기 (리팩토링용)
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor" })

-- ==========================================
-- [4] 터미널 단축키
-- ==========================================
map("n", "<Leader>th", function()
  vim.cmd("split")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal (horizontal)" })

map("n", "<Leader>tv", function()
  vim.cmd("vsplit")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Terminal (vertical)" })

-- ==========================================
-- [5] 빌드
-- ==========================================

-- Make 실행
map("n", "<leader>m", function()
  vim.cmd("write")
  vim.cmd("!make")
end, { desc = "Save & make" })

-- Make fclean
map("n", "<leader>mc", function()
  vim.cmd("!make fclean")
end, { desc = "make fclean" })
