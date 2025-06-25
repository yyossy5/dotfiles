" https://github.com/esm7/obsidian-vimrc-support

" --- クリップボード設定 ---
" ヤンク・削除した内容をOSのクリップボードと共有する
set clipboard=unnamed

" --- キーマッピング ---
" <leader>キーをスペースに設定する場合 (任意)
unmap <Space>
"let mapleader = " "

imap jk <Esc>

" タブの移動
exmap tabprev obcommand workspace:previous-tab
nmap gT :tabprev<cr>
exmap tabnext obcommand workspace:next-tab
nmap gt :tabnext<cr>

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>

" ----- Range Error 対策 -----
" https://github.com/esm7/obsidian-vimrc-support/issues/266
" remove map to o
nunmap o
map o A<CR>
" remove map to O
nunmap O
map O I<CR><Esc>ki
