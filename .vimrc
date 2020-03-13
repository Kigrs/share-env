" setting
"文字コードをUFT-8に設定
set fenc=utf-8
set encoding=utf-8
set fileencoding=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" yでコピーした時にクリップボードに入る
set guioptions+=a
" ヤンクでクリップボードにコピー
set clipboard=unnamed,autoselect

"viとの互換性を無効にする(INSERT中にカーソルキーが有効になる)
set nocompatible
"カーソルを行頭，行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,],~
" delete で文字削除
set backspace=indent,eol,start

" 見た目系
" 省略されずに表示
set display=lastline
" 端でスクロールしない
set scrolloff=3
" 行番号を表示
set number
" 現在の行を強調表示（縦）
"set cursorcolumn
" 現在の行をハイライト
set cursorline
" 上と合わせることで行番号のみハイライト
hi clear CursorLine
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" 改行時に前の行のインデントを継続する
set autoindent
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
"set visualbell
" エラーメッセージの表示時にビープを鳴らさない
set noerrorbells
" 括弧入力時の対応する括弧を表示
set showmatch
" メッセージ表示欄を2行確保
"set cmdheight=2
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk

vnoremap j gj
vnoremap k gk
vnoremap <Down> gj
vnoremap <Up>   gk

"inoremap <Down> <down>
"inoremap <Up>   <up>
" シンタックスハイライトの有効化
syntax enable

" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:»-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
" 行頭でのTab文字の表示幅
set shiftwidth=4
" タブキー押下時に挿入される文字幅を指定
set softtabstop=4


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nnoremap <Esc><Esc> :nohlsearch<CR>
" 置換の際のgオプションをデフォルトで有効化する
set gdefault


" ウィンドウの縦幅
"set lines=55
" ウィンドウの横幅
"set columns=180
" カラースキーム
colorscheme pencil

" defalt colors (/usr/share/vim/vim80/colors/)
"darkblue delek elflord industry morning pablo ron　slate　zellner
"blue　default　desert　evening　koehler　murphy　peachpuff　shine　torte

" custom colors (~/.vim/colors)
" anderson.vim     focusedpanic.vim mouse_v2.vim     novum.vim        pulumi.vim
" blade_runner.vim mouse.vim        nebula.vim       pencil.vim       silenthill.vim

" ダーク系のカラースキームを使う
set background=dark



" コマンドラインの履歴を10000件保存する
set history=10000


" スペルチェック機能を使う
"set spell
"set spelllang=en,cjk "日本語を除外

" iTerm2でインサートモード時のカーソルの形状を変化させる
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"


" ステータスラインの設定

" ファイル名表示
set statusline=%F
" 変更チェック表示
set statusline+=%m
" 読み込み専用かどうか表示
set statusline+=%r
" ヘルプページなら[HELP]と表示
set statusline+=%h
" プレビューウインドウなら[Prevew]と表示
set statusline+=%w
" これ以降は右寄せ表示
set statusline+=%=
" file encoding
set statusline+=[ENC=%{&fileencoding}]
" 現在行数/全行数
set statusline+=[LOW=%l/%L]

" マウスクリックを無効化する
set mouse=

" undoの履歴を残して、ファイルを閉じた後でもundoができるようにする
set undodir=~/.vim/undo
set undofile

" J/L で行頭/行末へ移動
noremap <S-j>   ^
noremap <S-l>   $
" U で REDO する 
nnoremap U <C-r>
" Ctrl + d で先の文字を消す
inoremap <c-d> <delete>


" 検索マッチ数を表示する
"nnoremap <expr> / _(":%s/<Cursor>/&/gn")
"function! s:move_cursor_pos_mapping(str, ...)
"    let left = get(a:, 1, "<Left>")
"    let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
"    return substitute(a:str, '<Cursor>', '', '') . lefts
"endfunction

"function! _(str)
"    return s:move_cursor_pos_mapping(a:str, "\<Left>")
"endfunction
