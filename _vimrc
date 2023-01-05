syntax on                  " Enable syntax highlighting.
filetype plugin indent on  " Enable file type based indentation.

set nocompatible
set hidden                 " Opening a new when buffer has unsaved changes hides instead of closes file

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

set number                 " Show line number
set relativenumber         " Show relative line number


" tell vim where to put swap files
if empty(glob('~/.vim/tmp'))
    silent !mkdir -p ~/.vim/tmp
endif
set dir=~/.vim/tmp
set backupdir=/Users/twillett/.vim/tmp

" Set up persistant undo dir
set undofile
set undodir='~/.vim/tmp/.undo//'

" Set director for viminfo file
set viminfo+=n~/.vim/.viminfo

set wildmenu
set wildmode=list:longest,full
set encoding=utf-8

set hidden
set nowrap        " don't wrap lines
set backspace=indent,eol,start
                    " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                    "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
                    "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set foldlevel=0   " expand folds by default

"Move the preview window (code documentation) to the bottom of the screen, so it doesn't move the code!
"You might also want to look at the echodoc plugin
set splitbelow

" Get Code Issues and syntax errors
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
" If you are using the omnisharp-roslyn backend, use the following
" let g:syntastic_cs_checkers = ['code_checker']
augroup omnisharp_commands
    autocmd!

    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

    " Synchronous build (blocks Vim)
    "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
    " Builds can also run asynchronously with vim-dispatch installed
    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
    " automatic syntax check on events (TextChanged requires Vim 7.4)
    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

    " Automatically add new cs files to the nearest project on save
    autocmd BufWritePost *.cs call OmniSharp#AddToProject()

    "show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    "The following commands are contextual, based on the current cursor position.

    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
    "finds members in the current buffer
    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
    " cursor can be anywhere on the line containing an issue
    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
    autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
    "navigate up by method/property/field
    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
    "navigate down by method/property/field
    autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>

augroup END

" cscope abreviations
if has('cscope')
  set cscopetag cscopeverbose

  if has('quickfix')
    set cscopequickfix=s-,c-,d-,i-,t-,e-
  endif

  cnoreabbrev csa cs add
  cnoreabbrev csf cs find
  cnoreabbrev csk cs kill
  cnoreabbrev csr cs reset
  cnoreabbrev css cs show
  cnoreabbrev csh cs help

  command -nargs=0 Cscope cs add $VIMSRC/src/cscope.out $VIMSRC/src

  " havent got thse working yet
  "nnoremap <leader>csa :csa<cr>
  "nnoremap <leader>csf :csf<cr>
  "nnoremap <leader>csk :csk<cr>
  "nnoremap <leader>csr :csr<cr>
  "nnoremap <leader>css :css<cr>
  "nnoremap <leader>csh :csh<cr>
endif

" this setting controls how long to wait (in ms) before fetching type / symbol information.
set updatetime=500
" Remove 'Press Enter to continue' message when type information is longer than one line.
set cmdheight=2

" Contextual code actions (requires CtrlP or unite.vim)
nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
" Run code actions with text selected in visual mode to extract method
vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

" rename with dialog
nnoremap <leader>nm :OmniSharpRename<cr>
nnoremap <F2> :OmniSharpRename<cr>
" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>
" Load the current .cs file to the nearest project
nnoremap <leader>tp :OmniSharpAddToProject<cr>

" (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
nnoremap <leader>ss :OmniSharpStartServer<cr>
nnoremap <leader>sp :OmniSharpStopServer<cr>

" Add syntax highlighting for types and interfaces
nnoremap <leader>th :OmniSharpHighlightTypes<cr>
"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
inoremap <C-Space> <c-x><c-o>

nnoremap <c-u><c-d> :OmniSharpRunTestFixture<cr>

" set nocompatible
" source $VIMRUNTIME/mswin.vim

" behave mswin

if has("autocmd")
    autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
endif

" Download and install vim-plug (cross platform).
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Manage plugins with vim-plug.
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-unimpaired'
"Plug 'tpope/vim-vikegar'
Plug 'mileszs/ack.vim'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-projectionist'
Plug 'elzr/vim-json'
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'ycm-core/YouCompleteMe'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'alepez/vim-gtest'
Plug 'tpope/vim-fugitive'
" Fugitive github plugin'
Plug 'tpope/vim-rhubarb'
Plug 'vim-syntastic/syntastic'
Plug 'fsharp/vim-fsharp', { 'for': 'fsharp', 'do': 'make fsautocomplete' }
Plug 'rhysd/vim-clang-format'
Plug 'gfontenot/vim-xcode'
Plug 'airblade/vim-gitgutter' 
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
"Plug 'dense-analysis/ale'
Plug 'preservim/tagbar'
"Plug 'garbas/vim-snipmate'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-commentary'
Plug 'pboettch/vim-cmake-syntax'
call plug#end()

colorscheme dracula

let c_no_curly_error = 1

let NERDTreeShowBookmarks = 1  " Display bookmarks on startup.
"autocmd VimEnter * NERDTree  " Enable NERDTree on Vim startup.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" automatically strip trailing whitespace on save
" autocmd BufWritePre * %s/\s\+$//e

" vim-rhubard (fugitive github plugin)
" let g:github_enterprise_urls = ['https://github.qualcomm.com']

" custom mappings
nnoremap <Space> <nop>
map <Space> <Leader>

" block comment
nnoremap <leader>c :normal 0^i//<CR>

" open fuzzy search
nnoremap <C-p> :<C-u>CtrlP .<CR>

" MERD TREE
" toggle nerd tree
nnoremap <leader>s :<C-u>NERDTreeToggle<CR>

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
nnoremap <leader>rs :<C-u>YcmRestartServer<CR>
" Rust Java
nnoremap <leader>ex :<C-u>YcmCompleter ExecuteCommand<CR>
" Roslyn
nnoremap <leader>rl :<C-u>YcmCompleter ReloadSolution<CR>

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

" clang-format settings
let g:clang_format#autoformat_on_insert_leave = 1
let g:clang_format#detect_style_file = 1

" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>

let g:xcode_workspace_file = '~/repos/DlpeMac/Mac/DLP/Build/DLPeMac.xcworkspace/contents.xcworkspacedata'
let g:xcode_default_scheme = 'BuildAll'

" tagbar mappings
nnoremap <leader>d :TagbarToggle<CR>
