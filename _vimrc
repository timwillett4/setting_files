syntax on                  " Enable syntax highlighting.
filetype plugin indent on  " Enable file type based indentation.

" gvim options
set guioptions-=m          " Remove Menu Bars
set guioptions-=T          " Remove Tool Bar
set guioptions-=r          " Remove Right Hand Scroll Bar
set guioptions-=L          " Remove Left Hand Scroll Bar

set autoindent             " Respect indentation when starting a new line.
set expandtab              " Expand tabs to spaces. Essential in Python.
set tabstop=4              " Number of spaces tab is counted for.
set shiftwidth=4           " Number of spaces to use for autoindent.

set backspace=2            " Fix backspace behavior on most terminals.
set foldmethod=syntax

set number
set relativenumber

" Set up persistant undo dir
set undofile
set undodir="C:/Program Files/Vim/vimfiles/undodir/"

" Set director for swap (recovery) files
set directory="C:/Program Files/Vim/vimfiles/swap/"

set wildmenu
set wildmode=list:longest,full
set encoding=utf-8

set hlsearch
" Download and install vim-plug (cross platform).
if empty(glob(
    \ '$VIMHOME/' . (has('win32') ? 'vimfiles' : '.vim') . '/autoload/plug.vim'))
  execute '!curl -fLo ' .
    \ (has('win32') ? "C:/Program Files/Vim/vimfiles" : '$HOME/.vim') .
    \ '/autoload/plug.vim --create-dirs ' .
    \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter *
    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|   PlugInstall --sync | q
    \| endif
endif

" Manage plugins with vim-plug.
call plug#begin('C:/Program Files/Vim/vimfiles/bundle')

Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'mileszs/ack.vim'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'tpope/vim-projectionist'
Plug 'elzr/vim-json'
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'ycm-core/YouCompleteMe'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'alepez/vim-gtest'
Plug 'tpope/vim-fugitive'
Plug 'vim-syntastic/syntastic'
Plug 'fsharp/vim-fsharp', { 'for': 'fsharp', 'do': 'make fsautocomplete' }

call plug#end()

colorscheme dracula         " Change a colorscheme.

let c_no_curly_error = 1

let NERDTreeShowBookmarks = 1  " Display bookmarks on startup.
"autocmd VimEnter * NERDTree  " Enable NERDTree on Vim startup.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" automatically strip trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" custom mappings
nnoremap <Space> <nop>
map <Space> <Leader>

" open fuzzy search
nnoremap <C-p> :<C-u>FZF<CR>

" MERD TREE
" toggle nerd tree
nnoremap <C-s> :<C-u>NERDTreeToggle<CR>

" YCM Custom Mappings
nnoremap <leader>G :<C-u>YcmCompleter GoTo<CR>
nnoremap <leader>gi :<C-u>YcmCompleter GoToInclude<CR>
nnoremap <leader>gd :<C-u>YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gD :<C-u>YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :<C-u>YcmCompleter GoToImpresise<CR>
nnoremap <leader>gr :<C-u>YcmCompleter GoToReferences<CR>
" nnoremap <leader>gI :YcmCompleter GoToImplementation
nnoremap <leader>gI :<C-u>YcmCompleter GoToImplementationElseDeclaration<CR>
nnoremap <leader>gt :<C-u>YcmCompleter GoToType<CR>

nnoremap <leader>dt :<C-u>YcmCompleter GetType<CR>
nnoremap <leader>dT :<C-u>YcmCompleter GetTypeImpresise<CR>
nnoremap <leader>dp :<C-u>YcmCompleter GetParent<CR>
nnoremap <leader>dd :<C-u>YcmCompleter GetDoc<CR>
nnoremap <leader>dD :<C-u>YcmCompleter GetDocImpresise<CR>

nnoremap <leader>rf :<C-u>YcmCompleter FixIt<CR>
nnoremap <leader>rr :<C-u>YcmCompleter RefactorRename
" Rust Java
nnoremap <leader>ex :<C-u>YcmCompleter ExecuteCommand<CR>
nnoremap <leader>rs :<C-u>YcmCompleter RestartServer<CR>
" Roslyn
nnoremap <leader>rl :<C-u>YcmCompleter ReloadSolution<CR>

" GTest settings/appings
" @TODO replace with ENV_VAR after getting it working
let g:gtest#gtest_command = "python \"C:/gitroot/pil/bin/arm64-v8a/Release External/host/QProfilerLauncher.py\""
let g:gtest#highlight_failing_tests = 1
let g:gtest#test_filename_suffix = "Tests"

augroup GTest
	autocmd FileType cpp nnoremap <silent> <leader>tt :GTestRun<CR>
	autocmd FileType cpp nnoremap <silent> <leader>tu :GTestRunUnderCursor<CR>
	autocmd FileType cpp nnoremap          <leader>tc :GTestCase<space>
	autocmd FileType cpp nnoremap          <leader>tn :GTestName<space>
	autocmd FileType cpp nnoremap <silent> <leader>te :GTestToggleEnabled<CR>
	autocmd FileType cpp nnoremap <silent> ]T         :GTestNext<CR>
	autocmd FileType cpp nnoremap <silent> [T         :GTestPrev<CR>
	autocmd FileType cpp nnoremap <silent> <leader>tf :CtrlPGTest<CR>
	autocmd FileType cpp nnoremap <silent> <leader>tj :GTestJump<CR>
	autocmd FileType cpp nnoremap          <leader>ti :GTestNewTest<CR>i
augroup END

