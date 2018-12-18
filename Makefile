# https://stackoverflow.com/questions/5553352/how-do-i-check-if-file-exists-in-makefile
# sometime a later release of bash is desirable e.g. sdkman.
ifneq ("$(wildcard /usr/local/bin/bash)","")
  SHELL=/usr/local/bin/bash
else
  SHELL=/bin/bash
endif

PWD := $(shell pwd)
LOCAL_BIN := ~/.local/bin

UNAME := $(shell uname -s)
ifeq ($(UNAME),Linux)
    os_install = sudo apt-get install
    user_bashrc = ~/.bashrc
endif
ifeq ($(UNAME),Darwin)
    os_install = brew install
    user_bashrc = ~/.bash_profile
endif

# -----------------------------------------------------------------------------
.PHONY: all boostrap bashrc fonts vim coursier sdkman pyenv ammonite fzf
all: bootstrap bashrc fonts vim coursier sdkman pyenv ammonite fzf

bootstrap:
	@for tool in git curl vim; do                \
	  if ! command -v $${tool} &>/dev/null; then \
	  $(os_install) $${tool};                    \
	fi;                                          \
	done
	mkdir -p $(LOCAL_BIN)

bashrc:
	ln -sf $(PWD)/bashrc $(user_bashrc)
	[[ ! -e ~/env.d || -L ~/env.d ]] && rm -f ~/env.d && ln -sf $(PWD)/env.d ~/env.d


# -----------------------------------------------------------------------------
SpaceVim:
	[ ! -e ~/.SpaceVim ] && curl -sLf https://spacevim.org/install.sh | bash || true

vim: SpaceVim
	[[ ! -e ~/.vim || -L ~/.vim ]] && rm -f ~/.vim && ln -sf .SpaceVim ~/.vim
	[[ -f ~/.vimrc && ! -L ~/.vimrc ]]  && mv ~/.vimrc ~/.vimrc_back || rm -f ~/.vimrc
	[[ -f ~/.gvimrc && ! -L ~/.gvimrc ]]  && mv ~/.gvimrc ~/.gvimrc_back || rm -f ~/.gvimrc
	[[ ! -e ~/.SpaceVim.d || -L ~/.SpaceVim.d ]] && rm -f ~/.SpaceVim.d && ln -sf $(PWD)/SpaceVim.d ~/.SpaceVim.d
	[[ ! -e ~/.vim/after || -L ~/.vim/after ]] && rm -f ~/.vim/after && ln -sf $(PWD)/vim/after ~/.vim/

vim-venv:
	mkdir -p ~/venvs/vim && ln -sf $(PWD)/vim.Pipfile ~/venvs/vim/Pipfile
	cd ~/venvs/vim && PIPENV_VENV_IN_PROJECT=1 pipenv install --dev

# -----------------------------------------------------------------------------
fonts: bootstrap
	@echo "-- download & install [Nerd Fonts](https://nerdfonts.com/)"
	@[[ -e ~/.fonts/"Sauce Code Pro Nerd Font Complete Mono.ttf" ]]                                                       \
	  || ( mkdir -p ~/.fonts && cd ~/.fonts                                                                               \
	  && curl --remote-name --location https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip \
	  && unzip SourceCodePro.zip && rm -f SourceCodePro.zip )                                                             \
	# END

# -----------------------------------------------------------------------------
sdkman: bootstrap
	@echo "-- install [sdkman](https://sdkman.io/install)"
	@# XXX: sdkman is a shell function, and not initialized in make env.
	@if [[ ! -d ~/.sdkman ]]; then            \
	  curl -s "https://get.sdkman.io" | bash; \
	fi
	source ~/.sdkman/bin/sdkman-init.sh  \
	  && sdk update                      \
	  && sdk install java 8.0.191-oracle \
	  && sdk install scala 2.12.7        \
	  && sdk install gradle 4.10.2	     \
	  # END

coursier: bootstrap
	@echo "-- install [coursier](https://coursier.github.io/coursier/1.1.0-SNAPSHOT/docs/quick-start-cli)"
	@if ! command -v coursier &>/dev/null; then                         \
	  curl -L -o coursier https://git.io/coursier && chmod +x coursier; \
	  mkdir -p $(LOCAL_BIN) && mv coursier $(LOCAL_BIN);                \
	fi                                                                  \
	# END

ammonite: sdkman coursier
	@echo "-- install [ammonite](http://ammonite.io/#Ammonite-REPL)"
	@source $${HOME}/.sdkman/bin/sdkman-init.sh       \
	  && mkdir -p $(LOCAL_BIN) && cp amm $(LOCAL_BIN) \
	  && amm <<< 'println("hello from Ammonite!")'    \
	# END

# -----------------------------------------------------------------------------
fzf:
	@echo "-- install [fzf](https://github.com/junegunn/fzf.vim)"
	@[ ! -e ~/.fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || true
	@cd ~/.fzf && git pull && make install


shfmt:
	@echo "-- install [shfmt](https://github.com/mvdan/sh)"
	go get -u mvdan.cc/sh/cmd/shfmt

# -----------------------------------------------------------------------------
pyenv:	bootstrap
	@echo "-- install [pyenv](https://github.com/pyenv/pyenv#installation)"
	@if ! command -v pyenv &>/dev/null; then                 \
	  git clone https://github.com/pyenv/pyenv.git ~/.pyenv; \
	fi

pip: pyenv
	@echo "-- install python packages by calling pip_packages.sh"
	@eval "$(pyenv init -)" && ./pip_packages.sh

pre-commit:
	@echo "-- install pre-commit for this project."
	pre-commit install

# -----------------------------------------------------------------------------
ssh:
	@echo "-- setup ssh config"
	mkdir -p ~/.ssh && ln -sf $(PWD)/ssh_config ~/.ssh/config && chmod 600 ~/.ssh/config
