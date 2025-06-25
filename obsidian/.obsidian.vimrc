imap jk <Esc>


" yank内容をOSのクリップボードにもコピー
set clipboard=unnamed

exmap tabprev obcommand workspace:previous-tab
nmap gT :tabprev<cr>
exmap tabnext obcommand workspace:next-tab
nmap gt :tabnext<cr>
