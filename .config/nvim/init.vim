let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'lukesmithxyz/vimling'
Plug 'vimwiki/vimwiki'
Plug 'bling/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
Plug 'lifepillar/vim-mucomplete'
Plug 'lervag/vimtex'
" Plug 'sirver/ultisnips'
Plug 'KeitaNakamura/tex-conceal.vim'
Plug 'tomasr/molokai'
call plug#end()

set title
set bg=light
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set noruler
set laststatus=0
set noshowcmd

" Some basics:
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
" Enable autocompletion in command line:
	set wildmode=longest,list,full

" Enable mucomplete:
	set completeopt+=menuone
	set completeopt+=noselect
	set shortmess+=c   " Shut off completion messages
  	set belloff+=ctrlg " If Vim beeps during completion
	let g:mucomplete#enable_auto_at_startup = 1
	let g:mucomplete#chains = { 'markdown': ['file', 'uspl', 'keyn'] }

" Colorscheme
	colorscheme molokai
	set termguicolors

" Check this link for the following code for correct colors in st:
"(https://stackoverflow.com/questions/62702766/termguicolors-in-vim-makes-everything-black-and-white)
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" " Define default completion chain
" let g:mucomplete#chains = { 'default':
"             \ [ 'ulti','omni','tags','keyn','keyp','path','line'] }

" Spellcheck highlights:
	hi clear SpellBad
	hi SpellBad cterm=underline ctermfg=LightRed

" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>
" Goyo plugin makes text more readable when writing prose:
	map <leader>f :Goyo \| set bg=light \| set linebreak<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" Nerd tree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
    endif

" vimling:
	nm <leader><leader>d :call ToggleDeadKeys()<CR>
	imap <leader><leader>d <esc>:call ToggleDeadKeys()<CR>a
	nm <leader><leader>i :call ToggleIPA()<CR>
	imap <leader><leader>i <esc>:call ToggleIPA()<CR>a
	nm <leader><leader>q :call ToggleProse()<CR>

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Replace ex mode with gq
	map Q gq

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck -x %<CR>

" Open my bibliography file in split
	map <leader>b :vsp<space>$BIB<CR>
	map <leader>r :vsp<space>$REFER<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler "<c-r>%"<CR>

" Open corresponding .pdf/.html or preview
	map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex
	let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writing
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Automatically deletes all trailing whitespace and newlines at end of file on save.
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Function for toggling the bottom statusbar:
let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>

" Navigating with guides in LaTeX and others
	inoremap <leader><leader> <Esc>/<++><Enter>"_c4l
	vnoremap <leader><leader> <Esc>/<++><Enter>"_c4l
	map <leader><leader> <Esc>/<++><Enter>"_c4l

" Set spell automatically for markdown files
augroup markdownSpell
    autocmd!
    autocmd FileType markdown setlocal spell
    autocmd BufRead,BufNewFile *.md,*.rmd,*.Rmd setlocal spell
augroup END

"Markdown from: https://github.com/tallguyjenks/.dotfiles/commit/7bbb6205b710c9060b09c0fb237ec5bf3b1ccca3#diff-fbe49bd18cec25091f971b82d0da4e455e264d5f9af6e80e406efb026dbe6404
	" Code snippets
	" autocmd FileType md,rmd,Rmd inoremap ,li [<++>](<++>)<Space><++><Esc>T{i
	" autocmd FileType md,rmd,Rmd inoremap ,li test<Esc>i
	autocmd Filetype [rR]md,markdown inoremap <leader>s ~~~~<Space><++><Esc>F~hi
        autocmd Filetype [rR]md,markdown inoremap $ $$<Space><++><Esc>F$i
        autocmd Filetype [rR]md,markdown map <leader>w yiWi[<Esc>Ea](<Esc>pa)
        autocmd Filetype [rR]md,markdown inoremap <leader>n ---<CR><CR>
        autocmd Filetype [rR]md,markdown inoremap <leader>b ****<Space><++><Esc>F*hi
        autocmd Filetype [rR]md,markdown inoremap <leader>i __<Space><++><Esc>F_i
        autocmd Filetype [rR]md,markdown inoremap <leader>fn ^[]<Space><++><Esc>F[a
        autocmd Filetype [rR]md,markdown inoremap <leader>l [](<++>)<++><Esc>F[a
        autocmd Filetype [rR]md,markdown inoremap <leader>1 #<Space><CR><CR><++><Esc>2kA
        autocmd Filetype [rR]md,markdown inoremap <leader>2 ##<Space><CR><CR><++><Esc>2kA
        autocmd Filetype [rR]md,markdown inoremap <leader>3 ###<Space><CR><CR><++><Esc>2kA
        autocmd Filetype [rR]md,markdown inoremap <leader>4 ####<Space><CR><CR><++><Esc>2kA
        autocmd Filetype [rR]md,markdown inoremap <leader>5 #####<Space><CR><CR><++><Esc>2kA
        autocmd Filetype [rR]md,markdown inoremap <leader>6 ######<Space><CR><CR><++><Esc>2kA
        autocmd Filetype [rR]md inoremap <leader>r ```{r}<CR>```<CR><CR><++><Esc>2kO
        autocmd Filetype [rR]md inoremap <leader>py ```{python}<CR>```<CR><CR><++><Esc>2kO
        autocmd Filetype [rR]md inoremap <leader>p `r knitr::include_graphics("")`<Space><++><Esc>F"i
        autocmd Filetype [rR]md inoremap <leader>sub ~~<Space><++><Esc>F~i
        autocmd Filetype [rR]md inoremap <leader>sup ^^<Space><++><Esc>F^i

" Vimwiki Markdown cmd's, from: https://github.com/tallguyjenks/.dotfiles/commit/7bbb6205b710c9060b09c0fb237ec5bf3b1ccca3#diff-fbe49bd18cec25091f971b82d0da4e455e264d5f9af6e80e406efb026dbe6404


" ~~~~~ Diary Template
        autocmd FileType markdown inoremap <leader>diary #<Space><++><CR><CR><++><CR><CR>##<Space>DevLog<CR><CR><++><CR><CR><Esc>gg
" ~~~~~ This is for a vim wiki note template
        autocmd Filetype markdown inoremap <leader>note #<Space>Explain<CR><CR><CR><CR>#<Space>Documentation<CR><CR><++><CR><CR>#<Space>Code<CR><CR>```<++><CR><CR>#<Space> Documentation<CR><++><CR><CR>```<CR><CR><Esc>gg2ji
        autocmd Filetype markdown inoremap <leader>shnote #<Space>Explain<CR><CR><CR><CR>```sh<CR><CR><++><CR><CR>```<CR><CR>#<Space>Documentation<CR><CR><++><CR><CR><Esc>gg2ji
        autocmd Filetype markdown inoremap <leader>sh ```sh<CR><CR><CR><CR>```<Esc>2ki
        autocmd Filetype markdown inoremap <leader>sh ```{python}<CR><CR><CR><CR>```<Esc>2ki
 " ~~~~~ This inputs a NOW() timestamp
        autocmd Filetype markdown inoremap <leader>now *<CR><Esc>!!date<CR>A*<Esc>kJxA<CR><CR>

"LATEX
	" Word count:
	autocmd FileType tex map <leader>w :w !detex \| wc -w<CR>
	" Code snippets
	autocmd FileType tex inoremap ,fr \begin{frame}<Enter>\frametitle{}<Enter><Enter><++><Enter><Enter>\end{frame}<Enter><Enter><++><Esc>6kf}i
	autocmd FileType tex inoremap ,fi \begin{fitch}<Enter><Enter>\end{fitch}<Enter><Enter><++><Esc>3kA
	autocmd FileType tex inoremap ,exe \begin{exe}<Enter>\ex<Space><Enter>\end{exe}<Enter><Enter><++><Esc>3kA
	autocmd FileType tex inoremap ,em \emph{}<++><Esc>T{i
	autocmd FileType tex inoremap ,bf \textbf{}<++><Esc>T{i
	autocmd FileType tex vnoremap , <ESC>`<i\{<ESC>`>2la}<ESC>?\\{<Enter>a
	autocmd FileType tex inoremap ,it \textit{}<++><Esc>T{i
	autocmd FileType tex inoremap ,ct \textcite{}<++><Esc>T{i
	autocmd FileType tex inoremap ,cp \parencite{}<++><Esc>T{i
	autocmd FileType tex inoremap ,glos {\gll<Space><++><Space>\\<Enter><++><Space>\\<Enter>\trans{``<++>''}}<Esc>2k2bcw
	autocmd FileType tex inoremap ,x \begin{xlist}<Enter>\ex<Space><Enter>\end{xlist}<Esc>kA<Space>
	autocmd FileType tex inoremap ,ol \begin{enumerate}<Enter><Enter>\end{enumerate}<Enter><Enter><++><Esc>3kA\item<Space>
	autocmd FileType tex inoremap ,ul \begin{itemize}<Enter><Enter>\end{itemize}<Enter><Enter><++><Esc>3kA\item<Space>
	autocmd FileType tex inoremap ,li <Enter>\item<Space>
	autocmd FileType tex inoremap ,ref \ref{}<Space><++><Esc>T{i
	autocmd FileType tex inoremap ,tab \begin{tabular}<Enter><++><Enter>\end{tabular}<Enter><Enter><++><Esc>4kA{}<Esc>i
	autocmd FileType tex inoremap ,ot \begin{tableau}<Enter>\inp{<++>}<Tab>\const{<++>}<Tab><++><Enter><++><Enter>\end{tableau}<Enter><Enter><++><Esc>5kA{}<Esc>i
	autocmd FileType tex inoremap ,can \cand{}<Tab><++><Esc>T{i
	autocmd FileType tex inoremap ,con \const{}<Tab><++><Esc>T{i
	autocmd FileType tex inoremap ,v \vio{}<Tab><++><Esc>T{i
	autocmd FileType tex inoremap ,a \href{}{<++>}<Space><++><Esc>2T{i
	autocmd FileType tex inoremap ,sc \textsc{}<Space><++><Esc>T{i
	autocmd FileType tex inoremap ,chap \chapter{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex inoremap ,sec \section{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex inoremap ,ssec \subsection{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex inoremap ,sssec \subsubsection{}<Enter><Enter><++><Esc>2kf}i
	autocmd FileType tex inoremap ,st <Esc>F{i*<Esc>f}i
	autocmd FileType tex inoremap ,beg \begin{DELRN}<Enter><++><Enter>\end{DELRN}<Enter><Enter><++><Esc>4k0fR:MultipleCursorsFind<Space>DELRN<Enter>c
	autocmd FileType tex inoremap ,up <Esc>/usepackage<Enter>o\usepackage{}<Esc>i
	autocmd FileType tex nnoremap ,up /usepackage<Enter>o\usepackage{}<Esc>i
	autocmd FileType tex inoremap ,tt \texttt{}<Space><++><Esc>T{i
	autocmd FileType tex inoremap ,bt {\blindtext}
	autocmd FileType tex inoremap ,nu $\varnothing$
	autocmd FileType tex inoremap ,col \begin{columns}[T]<Enter>\begin{column}{.5\textwidth}<Enter><Enter>\end{column}<Enter>\begin{column}{.5\textwidth}<Enter><++><Enter>\end{column}<Enter>\end{columns}<Esc>5kA
	autocmd FileType tex inoremap ,rn (\ref{})<++><Esc>F}i

""" Vim-LaTeX
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

""" TeX conceal
set conceallevel=1
let g:tex_conceal='abdmg'
hi Conceal ctermbg=none

""" ultisnips
" let g:UltiSnipsExpandTrigger = '<tab>'
" let g:UltiSnipsJumpForwardTrigger = '<tab>'
" let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
" let g:UltiSnipsSnippetDirectories=["UltiSnips", "ulti-snippets"]
" let g:UltiSnipsExpandTrigger="<C-right>"
" let g:UltiSnipsJumpForwardTrigger="<C-right>"
" let g:UltiSnipsJumpBackwardTrigger="<C-left>"

" " Pair ultisnips and mucomplete
" fun! TryUltiSnips()
"     let g:ulti_expand_or_jump_res = 0
"     if !pumvisible() " With the pop-up menu open, let Tab move down
"         call UltiSnips#ExpandSnippetOrJump()
"     endif
"     return ''
" endf

" fun! TryMUcomplete()
"     return g:ulti_expand_or_jump_res ? "" : "\<plug>(MUcompleteFwd)"
" endf

" let g:mucomplete#no_mappings  = 1 " Don't do any mappings I will do it myself

" " Extend completion
" imap <expr> <S-tab> mucomplete#extend_fwd("\<right>")

" " Cycle through completion chains
" imap <unique> <c-'> <plug>(MUcompleteCycFwd)
" imap <unique> <c-;> <plug>(MUcompleteCycBwd)

" " Try to expand snippet, if fails try completion.
" inoremap <plug>(TryUlti) <c-r>=TryUltiSnips()<cr>
" imap <expr> <silent> <plug>(TryMU) TryMUcomplete()
" imap <expr> <silent> <tab> "\<plug>(TryUlti)\<plug>(TryMU)"
" " Map tab in select mode as well, otherwise you won't be able to jump if a snippet place
" " holder has default value.
" snoremap <silent> <tab> <Esc>:call UltiSnips#ExpandSnippetOrJump()<cr>
" " Autoexpand if completed keyword is a snippet
" inoremap <silent> <expr> <plug>MyCR mucomplete#ultisnips#expand_snippet("\<cr>")
" imap <cr> <plug>MyCR
