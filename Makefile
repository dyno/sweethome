# https://stackoverflow.com/questions/5553352/how-do-i-check-if-file-exists-in-makefile
# sometime a later release of bash is desirable e.g. sdkman.
ifneq ($(wildcard /usr/local/bin/bash),)
  SHELL=/usr/local/bin/bash
else
  SHELL=/bin/bash
endif

PWD := $(shell pwd)
HOME_BIN := $${HOME}/bin

UNAME := $(shell uname -s)
ifeq ($(UNAME),Linux)
    user_bashrc = $${HOME}/.bashrc
    install_boostrap_packages = sudo apt install git
    fonts_dir = $${HOME}/.local/share/fonts
endif
ifeq ($(UNAME),Darwin)
    user_bashrc = $${HOME}/.bash_profile
    install_boostrap_packages = ./scripts/brew_packages.sh
    fonts_dir = $${HOME}/Library/Fonts
endif

ifneq ($(wildcard /usr/bin/yum),)
  PKGMGR := yum
endif
ifneq ($(wildcard /usr/bin/apt),)
  PKGMGR := apt
endif


LOCAL := $(HOME)/local

# used for backup timestamp
TS := $(shell date +"%Y%m%d_%H%M%S")

.DEFAULT_GOAL := usage

# -----------------------------------------------------------------------------
.PHONY: usage
usage:
	@echo "It's better to read the Makefile first ..."

.PHONY: all
all: bootstrap bashrc fonts coursier sdkman pyenv go fzf

.PHONY: boostrap
bootstrap:
ifeq ($(UNAME),Darwin)
	command -v brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
endif
	$(install_boostrap_packages)

.PHONY: git-config
git-config:
	git config --global user.email "dyno.fu@gmail.com"
	git config --global user.name "Dyno Fu"
	git config credential.helper 'cache --timeout=600'

.PHONY: vim neovim
vim: neovim
neovim:
ifeq ($(UNAME),Linux)
ifeq ($(PKGMGR),yum)
	sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	sudo yum install -y neovim
else
	[[ -e ~/bin/nvim ]] || (mkdir ~/bin \
		&& cd ~/bin \
		&& curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage \
		&& chmod +x nvim.appimage \
		&& ln -s nvim.appimage nvim)
endif
endif
ifeq ($(UNAME),Darwin)
	brew install neovim
endif

liquidprompt:
	[[ -d ~/gitroot/liquidprompt ]] && cd ~/gitroot/liquidprompt && git pull || true
	[[ ! -d ~/gitroot/liquidprompt ]] && mkdir -p ~/gitroot && git -C ~/gitroot clone https://github.com/nojhan/liquidprompt || true
	mkdir -p ~/.config && cp liquidpromptrc ~/.config/liquidpromptrc

.PHONY: bashrc
bashrc: liquidprompt neovim
	ln -sf $${PWD}/bashrc $(user_bashrc)
	[[ ! -e ~/env.d || -L ~/env.d ]] && rm -f ~/env.d && ln -sf $${PWD}/env.d ~/env.d


# -----------------------------------------------------------------------------
#  ## Python ##
PYTHON_VERSION := 3.6.9

.PHONY: pyenv python
pyenv:
	@echo "-- install [pyenv](https://github.com/pyenv/pyenv#installation)"
	./scripts/install_or_upgrade_pyenv.sh

python: pyenv
ifeq ($(UNAME),Linux)
ifeq ($(PKGMGR),apt)
	sudo apt-get install --assume-yes \
	  build-essential                 \
	  libbz2-dev                      \
	  liblzma-dev                     \
	  libreadline-dev                 \
	  libsqlite3-dev                  \
	  libssl-dev                      \
	  zlib1g-dev                      \
	  # END
endif
ifeq ($(PKGMGR),yum)
	sudo yum groupinstall 'Development Tools'
	sudo yum install  --assumeyes \
	  bzip2-devel                 \
	  libsq3-devel                \
	  openssl-devel               \
	  readline-devel              \
	  xz-devel                    \
	  zlib-devel                  \
	  # END
endif
	~/.pyenv/bin/pyenv install --skip-existing --verbose $(PYTHON_VERSION)
endif
ifeq ($(UNAME),Darwin)
	brew install readline openssl sqlite3 zlib &>/dev/null || true
	CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include" \
	~/.pyenv/bin/pyenv install --skip-existing --verbose $(PYTHON_VERSION)
endif
	~/.pyenv/bin/pyenv global $(PYTHON_VERSION)
	python -m pip install --upgrade --ignore-installed pip


# -----------------------------------------------------------------------------

.PHONY: spacevim spacevim-install spacevim-config
spacevim: neovim python-neovim spacevim-install spacevim-config
spacevim-install:
	[[ ! -e ~/.SpaceVim ]] && curl -sLf https://spacevim.org/install.sh | bash || true
	[[ -d ~/.SpaceVim ]] && git pull

spacevim-config:
	[[ ! -e ~/.vim || -L ~/.vim ]] && rm -f ~/.vim && ln -sf .SpaceVim ~/.vim
	[[ ! -e ~/.ideavimrc || -L ~/.ideavimrc ]] && rm -f ~/.ideavimrc && ln -sf $${PWD}/ideavimrc ~/.ideavimrc
	[[ -f ~/.vimrc && ! -L ~/.vimrc ]]  && mv ~/.vimrc ~/.vimrc_back || rm -f ~/.vimrc
	[[ -f ~/.gvimrc && ! -L ~/.gvimrc ]]  && mv ~/.gvimrc ~/.gvimrc_back || rm -f ~/.gvimrc
	[[ ! -e ~/.SpaceVim.d || -L ~/.SpaceVim.d ]] && rm -f ~/.SpaceVim.d && ln -sf $${PWD}/SpaceVim.d ~/.SpaceVim.d
	[[ ! -e ~/.vim/after || -L ~/.vim/after ]] && rm -f ~/.vim/after && ln -sf $${PWD}/vim/after ~/.vim/

python-vim-jedi:
	# jedi need to be installed to the python that compiled into vim
	# https://jedi.readthedocs.io/en/latest/docs/installation.html
ifeq ($(UNAME),Darwin)
	/usr/local/bin/pip3 install --upgrade jedi
endif

NEOVIM_VENV := neovim3
python-neovim: neovim python
	  pip install --upgrade pip pipenv \
	  && cd venv-$(NEOVIM_VENV)        \
	  && pipenv install --system


python-essentials:
	pip install --upgrade pipenv poetry
	cd venv && pipenv install --system
	# XXX: black has conflict - 2019.10.15
	pip install black

# -----------------------------------------------------------------------------
# https://app.programmingfonts.org/#source-code-pro
# https://app.programmingfonts.org/#hack
fonts:
	# Source Code Pro
	@echo "-- download & install [Nerd Fonts](https://nerdfonts.com/) Sauce Code Pro"
	@[[ -e $(fonts_dir)/"Sauce Code Pro Nerd Font Complete Mono.ttf" ]]                                                   \
	  || ( mkdir -p $(fonts_dir) && cd $(fonts_dir)                                                                       \
	  && curl --remote-name --location https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip \
	  && unzip SourceCodePro.zip && rm -f SourceCodePro.zip )                                                             \
	# END

	# Workaround nerd gui mono font problem. https://github.com/ryanoasis/nerd-fonts/issues/318
	# Hack - for gvim on Linux
	for font in                                                                \
	  "Hack/Hack-Bold.ttf"                                                     \
	  "Hack/Hack-Italic.ttf"                                                   \
	  "Hack/Hack-Regular.ttf"                                                  \
	  "Hack/Hack-BoldItalic.ttf"                                               \
	  ; do                                                                     \
	    font_name=$$(basename "$${font}");                                     \
	    [[ -e "$(fonts_dir)/$${font_name}" ]] ||                               \
	    curl --location --output "$(fonts_dir)/$${font_name}"                  \
	      "https://github.com/powerline/fonts/blob/master/$${font}?raw=true" ; \
	done                                                                       \
	# END
ifeq ($(UNAME),Linux)
	fc-cache -f -v &>/dev/null && fc-list :mono | grep -i "Hack"
endif

.PHONY: tmux
tmux:
ifeq ($(UNAME),Darwin)
	brew install reattach-to-user-namespace
endif
	mkdir -p ~/.tmuxp && ln -sf $${PWD}/tmuxp/*.yaml ~/.tmuxp/
	[[ -e ~/.tmux.conf ]] && mv ~/.tmux.conf ~/.tmux.conf.$(TS) || true
	ln -s $${PWD}/tmux.conf ~/.tmux.conf

.PHONY: alacritty-config
alacritty-config:
	mkdir -p ~/.config/alacritty/
	ln -sf $(PWD)/alacritty.yml ~/.config/alacritty/

.PHONY: alacritty
alacritty: alacritty-config
ifeq ($(UNAME),Darwin)
	[[ -e alacritty ]] && git -C alacritty pull --rebase --autostash || git clone https://github.com/jwilm/alacritty.git
	# build and install
	cd alacritty      \
	  && make install \
	# END
	# install manpages
	cd alacritty                                                               \
	  && gzip -c extra/alacritty.man >/usr/local/share/man/man1/alacritty.1.gz \
	  && mkdir -p ~/.bash_completion.d                                         \
	  && cp extra/completions/alacritty.bash ~/.bash_completion.d/alacritty    \
	# END
endif


# -----------------------------------------------------------------------------
SCALA_VERSION  := 2.12.10
ALMOND_VERSION := 0.8.2
JAVA_VERSION   := 8.0.222-amzn
GRADLE_VERSION := 5.6.2

sdkman:
	@echo "-- install [sdkman](https://sdkman.io/install)"
	@# XXX: sdkman is a shell function, and can not be initialized in make env.
	@if [[ ! -d ~/.sdkman ]]; then            \
	  curl -s "https://get.sdkman.io" | bash; \
	fi

sdkman-packages: sdkman
	@echo "-- install java/scala/gradle with sdkman"
	source ~/.sdkman/bin/sdkman-init.sh       \
	  && sdk selfupdate force                 \
	  && sdk install java $(JAVA_VERSION)     \
	  && sdk install scala $(SCALA_VERSION)   \
	  && sdk install gradle $(GRADLE_VERSION) \
	  # END

coursier:
	@echo "-- install [coursier](https://coursier.github.io/coursier/1.1.0-SNAPSHOT/docs/quick-start-cli)"
	@if ! command -v coursier &>/dev/null; then                         \
	  curl -L -o coursier https://git.io/coursier && chmod +x coursier; \
	  mkdir -p $(HOME_BIN) && mv coursier $(HOME_BIN);                  \
	fi                                                                  \
	# END

amm: ammonite
ammonite: sdkman coursier
	@echo "-- install [ammonite](http://ammonite.io/#Ammonite-REPL)"
	[[ ! -e ~/.ammonite || -L ~/.ammonite ]] && rm -f ~/.ammonite && ln -sf $${PWD}/ammonite ~/.ammonite
	@source $${HOME}/.sdkman/bin/sdkman-init.sh     \
	  && mkdir -p $(HOME_BIN) && cp amm $(HOME_BIN) \
	  && amm <<< 'println("hello from Ammonite!")'  \
	# END

almond-installer: coursier
	@echo "-- install [almond](https://almond.sh/docs/quick-start-install)"
	coursier bootstrap \
	  -r jitpack \
	  -i user -I user:sh.almond:scala-kernel-api_$(SCALA_VERSION):$(ALMOND_VERSION) \
	  sh.almond:scala-kernel_$(SCALA_VERSION):$(ALMOND_VERSION) \
	  -o almond-installer
	./almond-installer --help

almond-install: almond-installer
	./almond-installer --install --force=true


# -----------------------------------------------------------------------------
#  ## Go ##
# as of 2019.10.15
GO_VERSION := 1.13.1
.PHONY: go
go:
ifeq ($(UNAME),Linux)
	# sudo apt install --yes golang  # XXX: too old
	[[ -e $(LOCAL)/go/bin/go ]] || (cd /tmp && curl -O https://dl.google.com/go/go$(GO_VERSION).linux-amd64.tar.gz \
	  && mkdir -p $(LOCAL) && cd $(LOCAL) && tar zxvf /tmp/go$(GO_VERSION).linux-amd64.tar.gz)
endif
ifeq ($(UNAME),Darwin)
	brew install go
endif

fzf: go
	@echo "-- install [fzf](https://github.com/junegunn/fzf.vim)"
	@[[ ! -e ~/.fzf ]] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || true
	@cd ~/.fzf && git pull --rebase && make install


shfmt:
	@echo "-- install [shfmt](https://github.com/mvdan/sh)"
	go get -u mvdan.cc/sh/cmd/shfmt

goofys:
	@echo "-- install [goofys](https://github.com/kahing/goofys)"
	go get -u github.com/kahing/goofys

gron:
	@echo "-- install [gron](https://github.com/tomnomnom/gron)"
	go get -u github.com/tomnomnom/gron

# -----------------------------------------------------------------------------
#  Formatters
# .py, .java, .scala, .sh, .yaml, .yml, .json, .md, .vim ...
google-java-format:
	cd $(HOME_BIN) \
	  && curl -L -O https://github.com/google/google-java-format/releases/download/google-java-format-1.6/google-java-format-1.6-all-deps.jar \
	  && ln -sf google-java-format-1.6-all-deps.jar google-java-format.jar

# -----------------------------------------------------------------------------
submodule:
	git submodule init
	git submodule update

bfg:
	@echo "-- install [bfg](https://rtyley.github.io/bfg-repo-cleaner/)"
	cd $(HOME_BIN) \
	  && curl -L -O http://repo1.maven.org/maven2/com/madgag/bfg/1.13.0/bfg-1.13.0.jar \
	  && ln -sf bfg-1.13.0.jar bfg.jar
