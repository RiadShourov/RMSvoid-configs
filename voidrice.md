---
title: User Guide for Personal VoidLinux Installation and Usage
output: pdf_document
---

# how to install and larbs voidlinux from luke smith:
* install void linux
* install following apps:
	> sudo xbps-install -S curl ntfs-3g void-repo-nonfree
* set suid for ntfs-3g:
	> sudo groupadd ntfsuser
	> sudo chown root:ntfsuser $(which ntfs-3g)
	> sudo chmod 4750 $(which ntfs-3g)
	> sudo usermod -aG ntfsuser rshourov
* create few folders in /media:
	> sudo mkdir -p /media/windows
	> sudo mkdir -p /media/collection
	> sudo mkdir -p /media/usba
	> sudo mkdir -p /media/usbb
	> sudo mkdir -p /media/usbc

* set /etc/fstab for ntfs drives:
	> sudo vim /etc/fstab:
		>> /dev/sda1 /media/windows ntfs-3g defaults 0 0
		>> /dev/sda4 /media/collection ntfs-3g defaults 0 0
* download larbs files:
	> curl -LO larbs.xyz/vlarbs.sh
	> sudo su
	># bash vlarbs.sh
	* reboot
* edit .local/bin/dmenumount:
	* edit line 26 (at mountusb function)to add rw and umask option:
		>> sudo -A mount "$chosen" "$mp" -o rw,umask=0000;...........
* add bangla locale:
	* uncomment bn.BD_UTF.8 at /etc/default/libc-locales
	* then- > sudo xbps-reconfigure -f glibc-locales

# accessing other partitions:
* very good tutorial: https://unix.stackexchange.com/questions/396904/fstab-mount-options-for-umask-fmask-dmask-for-ntfs-with-noexec

# set network using wpa_cli:
	> sudo wpa_cli
	> add_nework
	> set_network <0> ssid "Xiaomi_rms"
	> set_network <0> psk "aa.......41"
	> enable_network <0>
	> save_config
	> reconnect
	> quit



# how to set correct sound card:
* my default sound card is HDA Intel PCH, which is shown as Card 1
* create /etc/asound.conf:
	>defaults.ctl.card 1;
	>defaults.pcm.card 1;

# how to install ungoogled-chromium
* download ungoogled-chromium and unzip
* rename chromium_sandbox to chromium-sandbox and set-suid:
	> sudo chown root chromium-sandbox
	> sudo chmod 4755 chromium-sandbox
* install libatomic with xbps
* run chromium-wrapper
* link chromium-wrapper to .local/bin:
	> cd .local/bin
	> ln -s ~/Downloads/<ungoogled-chromium-folder>/chromium-wrapper .
* install inox browser extension-installer:
	> cd repos/
	> git clone https://github.com/gcarq/inoxunpack.git
* install python-pip3: sudo xbps-install -S python3-pip
* install requests module: sudo pip install requests
* cd to ~/repos/inoxunpack/
* download extensions:
	> ./inoxunpack.py ublock-origin
	> ./inoxunpack.py dbepggeogbaibhgnhhndojpepiihcmeb [this is for vimium]
	> ./inoxunpack.py fpnlpehjhijpamloppfjljenemeokfio [for night-shift]
* install extensions:
	) go to chrome://extensions
	) click Developer Mode
	) Click Load unpacked extensions
	) select folder
* an alternative to ublock is adnauseam: https://adnauseam.io/


# how to select proper graphic driver (intel):
* install intel driver:
	> sudo xbps-install -S xf86-video-intel
* blacklist nouveau
	> sudo vim /etc/modprobe.d/blacklist-nouveau.conf
		>> blacklist nouveau
		>> options nouveau modeset=0
	> sudo dracut -f
	> sudo reboot

* check display drivers
	> sudo xbps-install -S lshw
	> sudo lshw -c video
	> modinfo i915
* check current vga kernel drivers:
	> lspci -nnk | grep -i vga -A3 | grep 'in use'


# To use sound buttons on F1, F2, and F3:
* put these in ~/.config/sxhkd/sxhkdrc:
		# Audiokeys
		XF86AudioMute
			amixer sset Master toggle; refbar
		XF86Audio{Raise,Lower}Volume
			amixer sset Master 5%{+,-}; refbar
* reload dwm

# To use brightness buttons at F11 and F12:
* install xbacklight
* put these in ~/.config/sxhkd/sxhkdrc:
		XF86MonBrightnessUp
			xbacklight -inc 10
		XF86MonBrightnessDown
			xbacklight -dec 10
* edit sudoer file:
	> sudo visudo
	>> %wheel ALL=(ALL) NOPASSWD: /usr/bin/xbacklight
* put these in dwm config.h
	>> #include <X11/XF86keysym.h>
* compile and reload dwm

# install bangla keyboard probhat:
* follow instructions from here: https://coder360.blogspot.com/2019/07/bangla-unijoy-in-void-linux.html
* run ibus-setup
* input "ibus-daemon &" in .xprofile



# to install LaTeX:
	> sudo xbps-install -S texlive
* put these in .bash_profile:
	>> export PATH=$PATH:/opt/texlive/2019/bin/x86_64-linux
* now, you can search packages with:
	> tlmgr search --global biber
* install packages with:
	> sudo tlmgr install biber
* these link is useful: https://www.reddit.com/r/voidlinux/comments/c4rvge/anyone_know_how_to_get_latex_working/
* install ctex and collection-fontsrecommended, ctex has xetex which will be needed for xetex compilation (see .local/bin/compiler), other package has important fonts.
* install titling, framed for rmarkdown
* install latexbangla for bangla language support


# learnt vim commands:
* j
* k
* h
* l
* H - go to top of page
* L - go to end of page
* M - go to middle of page
* Ctl-u - go up half a page
* Ctl-d - go down half a page
* 0 - go to 1st of line
* $ - go to end of line
* gg - go to start line of file
* G - go to end line of file
* 2G - go to 2nd line
* i - insert
* a - insert after this letter
* o - insert a line below
* O - insert a line above
* I - insert mode at 1st of line
* A - insert mode after end of line
* w - go to next word start
* e - go to next word end
* b - go back at start of prev word
* x - delete character
* dd - delete current line
* 3dd - delete 3 lines
* dw - delete upto next start of word
* db - delete back upto prev start of word
* de - delete upto end of next word
* D - delete upto end of line
* C - delete upto end of line and insert/ change
* d2w/d2b/d2e - delete 2 words
* diw/daw - delete current word
* ciw/caw - delete current word and insert
* dis/das - delete current sentence
* cis/cas - delete current sentence and insert
* dip/dap - delete current paragraph
* cip/cap - delete current paragraph and insert
* J - append next line with current line
* v -visual mode
* gj - go to next line in visual
* gk - go to prev line in visual
* Y - yank current line
* y - yank current line in visual
* p - paste
* u - undo
* Ctl-r - redo
* r - replace
* R - replace mode
* . - repeat previous command or input
* Ctl-g - show file status and location
* / - search in forward direction
* ? - search in backward direction
* n - go to next instance of search
* N - go to prev instance of search
* % - go to the maching parenthesis like ), } or ]
* :w - save
* :wq - save and quit
* :x - save and quit
* ZZ - save and quit
* !q - quit not saving
* ZQ - quit not saving
* :s/old/new/g - substitute old with new on the current line
* :s/old/new - substitute old with new on the 1st instance
* :#,#s/old/new/g - change every occurence of old on the 02 lines, i.e. :198,199s/ol/pi/g.
* :%s/old/new/g - change every occurence in whole file
* :! followed by external command, i.e.':!rm voidrice' will delete this file
* :#,# w test will save from line to line to a file name test, i.e. :189,203 w test.txt
* :r test - retreive content of the file named test and insert here
* :set ic - ignore case, useful when searching
* set hls is - set the hlsearch and incsearch options; hlsearch is for highlighting the searched item, incsearch is highlighting during typing search command
* :help - to open vim help
* :help incsearch - open help for incsearch
* :help user-manual - user manual
* :edit ~/.vimrc - edit vimrc
* zz or z. - put current line to middle of screen
* zt - put current line to top of screen
* zb - put current line to bottom of screen
* Ctl-T - indent (also works on bullets)
* Ctl-D - outdent

# to install transmission for torrent support:
* install transmission and transmission-remote-cli
* edit ~/.local/share/applications/torrent.desktop to replace toradd with transadd (it is in .local/bin/)

# install for neovim:
* install python3-neovim
* install following vim plugins:
	* install nvim-r and deoplete
	* install fzf and fzf.vim
		> Plug 'junegunn/fzf'
		> Plug 'junegunn/fzf.vim'
* add following lines in vimrc:

" Fuzzy file finder
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
	nnoremap <c-t> :FZF<cr>
	augroup fzf
  		autocmd!
  		autocmd! FileType fzf
  		autocmd  FileType fzf set laststatus=0 noshowmode noruler
    		\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
	augroup END

* to add fzf in bash, put these in .bashrc:
	>	[ -f ~/.fzf.bash ] && source ~/.fzf.bash
	>     export FZF_DEFAULT_COMMAND='find .'

* this line helps saving in insert mode with F3:
	> inoremap <F3> <c-o>:w<cr><End>

# install the_silver_searcher to run with fzf.vim

# use vim as an R IDE: https://www.freecodecamp.org/news/turning-vim-into-an-r-ide-cd9602e8c217/
* install libressl, libressl-devel, libcurl-devel, libgmp, libgomp-devel, gcc-fortran, libgfortran-devel, blas-devel, lapack-devel with xbps
* install these R packages: devtools, lintr, languageserver
* install these vim plugins using vim-plug: jalvesaq/nvim-r, junegunn/fzf and fzf.vim, neoclide/coc.nvim
* for coc.vim plugin:
	* in root do these: curl -sL install-node.now.sh/lts | bash
	* also install yarn using xbps [don't know if it is required]
* Put some general settings for coc.nvim: https://octetz.com/posts/vim-as-go-ide
* install these coc extensions: coc-r-lsp, coc-vimlsp, coc-word, coc-lists, coc-python, coc-yaml, coc-diagnostic, coc-snippets.
* install vim-snippets with Plug
* set Tab as selection cycle key and Enter as selection key.
* install ctag for file tagging (need to learn more on this)

# Install sf package in R:
* sf package a dependency of units package, which needs libudunits. But libudunits is not available in VoidLinux.
* for udunits, we need to install expat and expat-devel from xbps.
* If any source package is needed, we can find it in AUR of archlinux. At any page there is a link for the source package. From aur we can find source package of udunits at: ftp://ftp.unidata.ucar.edu/pub/udunits/udunits-2.2.26.tar.gz
* unzip the folder.
* First, we need to configure it to install it at /usr, because in this file the default directory is /usr/local/
  > ./configure --prefix=/usr
* Then install:
  > sudo make
  > sudo make install
* install: > sudo xbps-install -S -f libgdal libgdal-devel libgdal-tools proj proj-devel geos geos-devel
* if it still shows that it cannot find proj_api.h, then install proj source from here: https://download.osgeo.org/proj/proj-6.2.0.tar.gz
	* install the source using setting prefix=/usr
	* then install proj and proj-devel using 'xbps-install -Sf'

* now install the R package using install.packages("sf")

# How to use R without sudo:
> sudo chown rshourov /home/rshourov -R


# Changes for surf browser:
* add following codes in ~/.config/surf/script.js:
* for link hinting: https://surf.suckless.org/files/link_hints
* for easier key: https://surf.suckless.org/files/easier_key
* for adblock: https://dev.ybad.name/OpenBSD-stuff/zerohosts
	* download the zerohosts file and put it in .local/bin
		> cd .local/bin
		> curl -L https://dev.ybad.name/OpenBSD-stuff/zerohosts > zerohosts
		> sudo chmod a+x zerohosts
	* edit the file and uncomment line 13 and comment line 14 (to enable curl and disable ftp)
	* run the file : > sudo zerohosts
* edit config.h:
	* set SmoothScrolling to 1 (line 59)
	* set Plugins 0
	* set Fonts to 14
	* set Zoom_Level to 1.2
	* edit shortcut keys (located at line 156)
	* set 'GDK_KEY_o' for spawn instead of 'g'
	* comment out GDK_KEY_f for find
	* put 'Shift-l' and 'Shift-h' for navigate forward and back
* in surf browser, C-y and C-Y will paste copied items in urlbar (called by o key)
* a code for guarantee link hinting in all pages: troubleshooters.com/linux/surf.htm
* edit the surf.c file to change GDK_SELECTION_PRIMARY to GDK_SELECTION_CLIPBOARD (line 1857 and line 1861); so that Selction_clipboard is the default clipboard for surf browser.
* To invert colors in all websites, put this line in defaults.css: >html, img, video { -webkit-filter: invert(95%) hue-rotate(180deg); }

# Some edits for zathura:
* put these in ~/.config/zathura/zathurarc:
* for working copy paste:
	> set selction-clipboard clipboard
* for recoloring dark and white backgrounds:
	> set recolor true
	> set recolor-lightcolor \#FFE4C4
	> set recolor-darkcolor \#839496
* for window title with file name:
	> set window-title-basename "true"

# How to setup torrent with qbittorrent:
* install qbittorrent-nox
* put "qbittorrent-nox --daemon &" in .xprofile
* remove transmission-daemon from init service:
	> sudo rm -r /var/service/transmission-daemon
* access qbittorrent in browser by http://localhost:8080
* current username: rms.qbit; pass: aa----67
* download torrent file and open with lf, it will automatically start in qbittorrent-nox.

# To symlink neovim settings to vim:
* Having your config in Neovim's default location, do the following:

	> mkdir -p ~/.local/share/nvim/site
	> ln -s ~/.local/share/nvim/site ~/.vim
	> ln -s .config/nvim/init.vim .vimrc

# install zsh:
* this link:https://medium.com/@Andreas_cmj/how-to-setup-a-nice-looking-terminal-with-wsl-in-windows-10-creators-update-2b468ed7c326
* another good link: https://github.com/unixorn/awesome-zsh-plugins
* copy .zshrc and .zprofile from Luke Smith's github

#  How to change mirrors of voidlinux
* copy all contents from /usr/share/xbps.d/ to /etc/xbps.d
* edit all respective files and edit the mirrors to "http://mirror.clarkson.edu/voidlinux/current"

# GitHub activation:
* This is a good link: http://www.coderholic.com/using-git-and-github-to-sync-config-files/


# How to setup pam-gnupg for mutt-wizard:
* clone: > git clone https://github.com/cruegge/pam-gnupg
* install these packages:
  	> sudo xbps-install -S mk-configure pam-devel
* cd to package directory. THen-
  	> ./autogen.sh
	> ./configure
	> sudo make

# How to setup neomutt:
* install: > sudo xbps-install -S neomutt isync msmtp pass notmuch abook urlview
* install muttwizard from [luke smith](https://github.com/LukeSmithxyz/mutt-wizard)
* run gpg2 for a mail: > gpg2 --full-gen-key
  	* setup related mail password
* run: > pass init <your mail address>
* now:> mw add
* to open various files using relevant apps:
	* edit muttwizard/share/mailcap before installing muttwizard; or
	* edit /usr/share/mutt-wizard/mailcap.
	* following are my current contents
		text/plain; $EDITOR %s ;
		text/html; openfile %s ; nametemplate=%s.html
		text/html; w3m -I %{charset} -T text/html; copiousoutput;
		#image/*; muttimage %s ; copiousoutput
		image/*; sxiv %s ; copiousoutput
		video/*; setsid mpv --quiet %s &; copiousoutput
		application/pdf; openfile %s ;
		application/pgp-encrypted; gpg -d '%s'; copiousoutput;
		application/vnd.openxmlformats-officedocument.wordprocessingml.document; loffice
		%s &; copiousoutput;
		application/msword; loffice %s &; copiousoutput;
		application/vnd.ms-excel; loffice %s &; copiousoutput;

# How to check size of a folder
> du -sh <folder>

# How to change root shell and prompt:
> sudu su
>chsh -s /bin/zsh
* copy .zshrc to /root/
* edit PS1 in .zshrc as you wish

# How to correct time:
* backup current localtime: > sudo mv /etc/localtime /etc/localtime.bak
* link to zone: > sudo ln -s /etc/share/zoneinfo/Asia/Dhaka /etc/localtime
* set date manually: > sudo date -s "29 OCT 2019 22:50:15"
* set hardware clock to system time: > sudo hwclock -w

# How to image preview in vifm:(tutorial: https://www.youtube.com/watch?v=qgxsduCO1pE)
* install ueberzug: sudo xbps-install -S python3-devel python3-psutil python3-Pillow python3-pillow-simd ueberzug
* if any error with wheel, then update setuptools and wheel: sudo pip install --upgrade wheel setuptools
* put 02 files in .config/vifm/scripts folder: vifmrun, vifmimg (from here: https://github.com/cirala/vifmimg)
* make the 02 files executable with sudo chmod a+x
* follow cirala git page to edit vifmrc
* link vifmrun in .local/bin:
  	> cd .local/bin
	> ln -s ~/.config/vifm/scripts/vifmrun .
* edit .bash_profile: export FILE='vifmrun'
* if there is any permission error like cannot load data_points or something like that then: sudo chmod -R a+rX /usr/lib/python3.6/site-packages (this maybe risky, don't do this if it is not required)
* the vifmimg file is used for previewing image, gif, video and pdf
* install ffmpegthumbnailer with xbps, which will also show video preview
* install ImageMagick using xbps for previewing gif (with convert command)
* install poppler-utils using xbps to preview pdf (using pdftoppm)
* install epub-thumbnailer to preview epub:
	> git clone https://github.com/marianosimone/epub-thumbnailer.git
	> cd epub-thumbnailer
	> sudo python install.py install
* edit the script vifmimg to change /tmp folder to $HOME/.config/vifm/tmp/

* alternatively, do not preview pdf, epub and djvu with ueberzug, rather use pdftotext for pdf, and mediainfo for epub and djvu:
  > fileviewer *.pdf pdftotext -l 1 -nopgbrk %c -
  > fileviewer *.epub mediainfo %c
  > fileviewer *.djvu mediainfo %c



# Some shortcuts for vifm:
* show hidden files with 'zo'
* hide hidden files again with 'zm'

# how to install jupyterlab, which will also install jupyter notebook:
> sudo pip install jupyterlab
* open jupyterlab with: > sudo jupyter lab --allow-root
* install vim extenstions:
	* 1st, enable extension manager in jupyterlab settings
	* install vim extension: sudo jupyter labextension install jupyterlab_vim
* install statsmodels package for various tools, which will also install numpy, scipy pandas etc: > sudo pip install statsmodels
* install matplotlib using pip

# do not ask password for shutdown or restart
* put these line in visudo:
> %wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/ZZZ,/usr/bin/wpa_cli,/usr/bin/mount,/usr/bin/umount,/usr/bin/loadkeys

# Open surf with tabbed:
* Dowload tabbed from git: git clone https://git.suckless.org/tabbed
* first: > make
* then, change 02 keys in config.h for rotate tab -1 and 1 with MODKEY and 'XK_j' and 'XK_k'
* then: > sudo make install
* I have created a small shell script 'tsurf', which will open the surf browser tabbed.
* The tsurf script has following line: > tabbed -r 2 surf -e lmao

# netstat command:
* to install netstat: > sudo xbps-install -S net-tools

# handle voidlinux services easily with vsv:
* Install:
	> cd ~/repos
	> git clone git://github.com/bahamas10/vsv.git
	> cd vsv/
	> ln -s vsv ~/.local/bin
* check service status, example: sudo vsv status alsa

# setup w3m and aria2 from gotbletu: (setup w3m external command, keybindings etc, dian-mui for aria etc)


# ricing bash:
* install bash_it from : https://github.com/Bash-it/bash-it
* important dotfiles from: http://dotfiles.github.io/
* install the_silver_searcher (ag), which provides aliases and others (haven't used it yet)
* install autojump: can autojump to folders
  	* from here: https://github.com/wting/autojump
	* after installing install.py, add lines to .bashrc (mentioned after installation)
	* enable it using bash_it: bash-it enable plugin autojump
	* another alternative is jump: https://github.com/gsamokovarov/jump

* another way is to install powerline-shell (https://github.com/b-ryan/powerline-shell):
  	> pip install --user powerline-shell
  	* generate config:
	  > mkdir -p ~/.config/powerline-shell && \
	    powerline-shell --generate-config > ~/.config/powerline-shell/config.json
		* remove "git" from config.json (which will minimize the bash prompt by removing git information)
		* add "time" in segments
		* create a new portion for time formats:
		  "time": {
		  	"format": "%I:%M"
		  }
	* remove previous PS1 and add these lines in .bashrc (for .zshrc it is different):
		function _update_ps1() {
    			PS1=$(powerline-shell $?)
		}

		if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    			PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
		fi
	* install nerd fonts:> sudo xbps-install -S nerd-fonts
	* recompile st terminal with following font: "Inconsolata Nerd Font"
	* restart st

* you can also install pfetch or neofetch and add them in .bashrc

# View video file properties using mediainfo command.

# Cleanly format pendrive (if it is used previously as bootable device):
* wipe all: sudo wipefs --all /dev/sdb
* repartition again with fdisk:
	> sudo fdisk /dev/sdb
		> n > p > enter > enter > enter > w
* reformat: sudo mkfs.vfat -F 32 /dev/sdb1

# create bootable usb:
* use dd: > sudo dd bs=4M if=path/to/linux.iso of=/dev/sdX status=progress oflag=sync
* or a good script is from here: https://github.com/jsamr/bootiso
  * install:
    > curl -L https://git.io/bootiso -O
    > chmod +x
    > mv bootiso ~/.local/bin
  * edit the script (at around 625 lines) to change label size to 20 characters. (don't know if it is very important)

# How to detect my bluetooth earpod (UiiSii TWS12):
* install following programs:
> sudo xbps-install -S bluez alsa alsa-plugins sbc sbc-devel libbluetooth libbluetooth-devel alsa-lib alsa-lib-devel alsa-utils
* download bluez-alsa from here: git clone https://github.com/Arkq/bluez-alsa.git
* follow following commands:
  > autoreconf --install
  > mkdir build && cd build
  > ../configure --disable-hcitop --with-alsaplugindir=/usr/lib/alsa-lib
  > make && sudo make install
* edit /etc/dbus-1/system.d/bluealsa.conf and put like following lines:

  <policy user="root">
    <allow own_prefix="org.bluealsa"/>
    <allow send_destination="org.bluealsa"/>
  </policy>

  <policy user="rshourov">
    <allow own_prefix="org.bluealsa"/>
    <allow send_destination="org.bluealsa"/>
  </policy>


  <policy group="audio">
    <allow send_destination="org.bluealsa"/>
  </policy>

* put a file as /usr/share/alsa/alsa.conf.d/20-bluealsa.conf, put info from from here: https://github.com/Arkq/bluez-alsa/blob/4d73f961eb0b3fbe16d5b9e01513727dfe07c432/src/asound/20-bluealsa.conf (don't know if this file really works)

* add this line in .xprofile: bluealsa &
* edit ~/.asoundrc as this:
pcm.!default {
	type plug
	slave {
		pcm {
			type bluealsa
			device "03:7B:06:69:0B:41"
			profile "a2dp"
		}
		}
	hint {
		show on
		description "UiiSii TWS12 Earpod"
	}
}

ctl.!default {
	type bluealsa
}


defaults.ctl.card 1;
defaults.pcm.card 1;

* from above .asoundrc file:
  * comment out bluealsa parts when using laptop soundbox
  * comment out card 1 part when using bluealsa device

* create 02 bash scripts in .local/bin
  * bthconnect:
    #!/usr/bin/env sh

    echo -e "power on\nconnect 03:7B:06:69:0B:41\nquit" | bluetoothctl

  * bthdisconnect:
    #!/usr/bin/env sh

    echo -e "disconnect 03:7B:06:69:0B:41\npower off\nquit" | bluetoothctl

  > chmod +x bthconnect
  > chmod +x bthdisconnect

* connect and disconnect using above 02 scripts
* you can check if bluetooth device is connected by:
  > espeak "Hello, how are you?" -w ~/espeak.wav -s145
  > aplay -D bluealsa:SRV=org.bluealsa,DEV=03:7B:06:69:0B:41,PROFILE=a2dp espeak.wav (it may not work)

* some good links:
  1) https://github.com/Arkq/bluez-alsa/issues/14
  2) https://forum.armbian.com/topic/6480-bluealsa-bluetooth-audio-using-alsa-not-pulseaudio/
  2) https://github.com/Arkq/bluez-alsa
  3) https://github.com/Arkq/bluez-alsa/issues/4
  4) https://github.com/Arkq/bluez-alsa/issues/26
  5) https://github.com/Arkq/bluez-alsa/blob/4d73f961eb0b3fbe16d5b9e01513727dfe07c432/src/asound/20-bluealsa.conf

# Limit mpv to open youtube videos at 720p video: https://github.com/mpv-player/mpv/issues/4241
* put this in .config/mpv/mpv.conf:
  > ytdl-format=bestvideo[height<=?720][fps<=?30][vcodec!=?vp9]+bestaudio/best

# install mate desktop:
* > xi -S mate
* add in .xinitrc: > exec mate-session
* remove dark borders around some mate windows:
	* add these in .config/gkt-3.0/gtk.css:
	  .window-frame {
	  box-shadow: none;
	  margin: 1px;
    	  }
* add a desktop entry for st terminal in .local/share/applications (https://wiki.archlinux.org/index.php/St)


# change default os in grub menu:
* install grub-customizer: sudo xbps-install -S grub-customizer
  * move Artix Linux in top

# How to set Xresources

- install xrdb: xi -S xrdb
- copy Luke Smith's Xresources from .config/, and put it in ~/
- uncomment dracula theme
- put this line in .xinitrc: [[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
- (This process is currently not working.)

# How to install doom-emacs in voidliunx

- install git, ripgrep, fd
- install emacs-gtk3
- clone this git using: git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
- Then: ~/.emacs.d/bin/doom install
- create a service from this page: [Emacs Service](https://github.com/matman26/emacs-config/tree/master/sv)

# How to install and setup spacemacs

- first backup previous .emacs.d/ and .emacs
- install from git: git clone -b develop https://github.com/syl20bnr/spacemacs ~/.emacs.d
- run emacs
- change these setting in spacemacs: (https://practicalli.github.io/spacemacs/install-spacemacs/emacsclient-server.html)
	- go to .spacemacs using SPC f e d
	- change these options:
		- dotspacemacs-enable-server t
		- dotspacemacs-persistent-server t
	- create a script called edit in .local/bin and sudo chmod a+x edit:

#!/bin/sh
/usr/bin/emacsclient $1 -a '' -n -c


- change frame-killer key to SPC q q (not working right now, maybe need to install evil-leader package) (https://medium.com/@bobbypriambodo/blazingly-fast-spacemacs-with-persistent-server-92260f2118b7)
- close emacs using SPC q f

# How to install voidlinux in qemu:
- [Void Linux Installation On QEMU](https://www.youtube.com/watch?v=-pZ9KjcATSM)
