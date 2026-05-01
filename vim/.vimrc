set nocompatible 
filetype off

" =========================
" VUNDLE
" =========================

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'beloglazov/vim-online-thesaurus'
Plugin 'VOoM'
Plugin 'surround.vim'
Plugin 'marvim'
Plugin 'iamcco/markdown-preview.nvim'
Plugin 'Rykka/riv.vim'
Plugin 'LaTeX-Suite-aka-Vim-LaTeX'
Plugin 'unimpaired.vim'
Plugin 'simeji/winresizer.git'
Plugin 'yaml.vim'
Plugin 'vifm.vim'
Plugin 'Rykka/InstantRst'

" Distraction-free writing
Plugin 'junegunn/goyo.vim'
Plugin 'lgalke/vim-ernest'
Plugin 'junegunn/limelight.vim'

call vundle#end()
filetype plugin indent on

" =========================
" COLOR + BASIC EDITING
" =========================

silent! colorscheme brogrammer
syntax on

set shiftwidth=4 softtabstop=4 expandtab
set autoindent
set path+=**
set wildmenu
set title
set number
set hlsearch

" Clipboard (all systems)
set clipboard=unnamedplus

:set wrap
:set linebreak
:set textwidth=0
:set wrapmargin=0

" GUI
:set guioptions=m
:set linespace=3
:set guifont=Monospace\ 11

" Status
set laststatus=2
set statusline+=%F

" =========================
" RUNTIME
" =========================

set runtimepath+=~/Work/dbd_zetteln/vim-scripts

" =========================
" FILETYPE + AUTOCMD
" =========================

au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim
au BufNewFile,BufFilePre,BufRead *.mdz set filetype=markdown

highlight nonascii guibg=Red ctermbg=1 term=standout
au BufReadPost * syntax match nonascii "[^\u0000-\u007F]"

" =========================
" MAPPINGS
" =========================

let mapleader = ","
inoremap jj <ESC>
noremap <leader>ev :EditVifm<CR>

map gs :above wincmd f<CR>
map gv :vertical wincmd f<CR>

" =========================
" VOOM
" =========================

let g:voom_python_versions = range(2,666)
let g:voom_tree_width = 60
let g:voom_always_allow_move_left = 1

" =========================
" RST
" =========================

let g:riv_global_leader = '<C-R>'

com RP :exec "Vst html" | w! /tmp/test.html | :q | !firefox /tmp/test.html

" =========================
" FORUM / TEXT COMMANDS
" =========================

command! DDProcessForumQuestions source ~/Work/dbd_zetteln/vim-scripts/process-forum-questions.vim
command! DDProcessForumQuestionsNew source ~/Work/dbd_zetteln/vim-scripts/process-forum-questions-new.vim
command! DDProcessForumComments source ~/Work/dbd_zetteln/vim-scripts/process-forum-comments.vim
command! DDProcessForumCommentsNew source ~/Work/dbd_zetteln/vim-scripts/process-forum-comments-new.vim
command! DDProcessForumCommentsGrading source ~/Work/dbd_zetteln/vim-scripts/process-forum-comments-grading.vim

command! DDDeletePipes execute '%s/|/|\r/g' | nohls

command -range=% DDInsertSingleLines :<line1>,<line2> g/.\n\n\@!/norm o
command -range=% DDRemoveDoubleEmptyLines1 :<line1>,<line2> s/\s\+$//e
command -range=% DDRemoveDoubleEmptyLines2 :<line1>,<line2> s/\n\{3,}/\r\r/e
command -range=% DDRemoveBetweenBrackets :<line1>,<line2> s/\[[^][]*\]//g
command -range=% DDBreakIntoSentences :<line1>,<line2> s/\([.!?]\) /\1\r\r/g 
command -range=% DDIndentLines :<line1>,<line2> s/^/  /g
command -range=% DDJoinAllParagraphs :<line1>,<line2> g/^./ .,/^$/-1 join
command -range=% DDRemoveTrailingSpace :<line1>,<line2> s/\s\+$//e
command -range=% DDRemoveWhiteSpaceBegin :<line1>,<line2> s/^\s\+//e
command -range=% DDAllCapsToTitle :<line1>,<line2> s/\v\C<([A-ZÀ-Ý])([A-ZÀ-Ý]+)>/\u\1\L\2/g
command -range=% DDRemoveCurlyQuotesDouble :<line1>,<line2> s/[”“]/"/g
command -range=% DDRemoveCurlyQuotesSingle :<line1>,<line2> s/’/'/g
command -range=% DDRemoveEmptyLines :<line1>,<line2> g/^\s*$/d
command -range=% DDCleanForumCSV %s/[‘’]/'/g | %s/[“”]/"/g | %s/[]/--/g

command! SheetView set wrap linebreak showbreak=↪\  cursorline
command! NoSheetView set nowrap nocursorline

nnoremap <leader>s :SheetView<CR>
nnoremap <leader>S :NoSheetView<CR>

command! DDDeleteFirstName %s/^\S\+\s\+//

" =========================
" MULTILINE SEARCH
" =========================

function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction

command! -bang -nargs=* -complete=tag S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR> 

" =========================
" LATEX SUITE
" =========================

let g:Imap_UsePlaceHolders = 0

" =========================
" MARKDOWN PREVIEW
" =========================

let g:mkdp_command_for_global = 1

" =========================
" CODEX ADDITIONS
" =========================

command! ArrowFix %s/→/>>/ge

function! ToggleCodexMode()
  if exists("b:codex_mode") && b:codex_mode
    let &l:wrap = b:orig_wrap
    let &l:linebreak = b:orig_linebreak
    syntax clear CodexComment
    echo "Codex mode OFF"
    let b:codex_mode = 0
  else
    let b:orig_wrap = &l:wrap
    let b:orig_linebreak = &l:linebreak

    setlocal wrap
    setlocal linebreak

    syntax match CodexComment /<!--.\{-}-->/
    highlight CodexComment ctermfg=Yellow guifg=Yellow gui=italic

    echo "Codex mode ON"
    let b:codex_mode = 1
  endif
endfunction

nnoremap <leader>c :call ToggleCodexMode()<CR>

" =========================
" WSL CLIPBOARD SAFETY
" =========================

if has('unix') && filereadable('/proc/version')
  let s:version = readfile('/proc/version')[0]
  if s:version =~? 'microsoft'
    nnoremap p p`[v`]:s/\r$//e<CR>
  endif
endif
