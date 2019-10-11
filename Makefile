# https://stackoverflow.com/questions/5553352/how-do-i-check-if-file-exists-in-makefile
# sometime a later release of bash is desirable e.g. sdkman.
ifneq ("$(wildcard /usr/local/bin/bash)","")
  SHELL=/usr/local/bin/bash
else
  SHELL=/bin/bash
endif

PWD := $(shell pwd)
HOME_BIN := $${HOME}/bin

UNAME := $(shell uname -s)
ifeq ($(UNAME),Linux)
    user_bashrc = $${HOME}/.bashrc
    install_boostrap_packages = ./scripts/apt_packages.sh
    fonts_dir = $${HOME}/.local/share/fonts
endif
ifeq ($(UNAME),Darwin)
    user_bashrc = $${HOME}/.bash_profile
    install_boostrap_packages = ./scripts/brew_packages.sh
    fonts_dir = $${HOME}/Library/Fonts
endif

# -----------------------------------------------------------------------------
all: bootstrap bashrc fonts vim coursier sdkman pyenv fzf

bootstrap:
ifeq ($(UNAME),Darwin)
	command -v brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
endif
	$(install_boostrap_packages)

liquidprompt:
	[[ -d ~/gitroot/liquidprompt ]] && cd ~/gitroot/liquidprompt && git pull || true
	[[ ! -d ~/gitroot/liquidprompt ]] && mkdir -p ~/gitroot && git -C ~/gitroot clone https://github.com/nojhan/liquidprompt || true
	mkdir -p ~/.config && cp liquidpromptrc ~/.config/liquidpromptrc

.PHONY: bashrc
bashrc: liquidprompt
	ln -sf $(PWD)/bashrc $(user_bashrc)
	[[ ! -e ~/env.d || -L ~/env.d ]] && rm -f ~/env.d && ln -sf $(PWD)/env.d ~/env.d


# -----------------------------------------------------------------------------

.PHONY: SpaceVim spacevim vim
SpaceVim:
	[[ ! -e ~/.SpaceVim ]] && curl -sLf https://spacevim.org/install.sh | bash || true
	[[ -d ~/.SpaceVim ]] && git pull

spacevim: SpaceVim
	[[ ! -e ~/.vim || -L ~/.vim ]] && rm -f ~/.vim && ln -sf .SpaceVim ~/.vim
	[[ ! -e ~/.ideavimrc || -L ~/.ideavimrc ]] && rm -f ~/.ideavimrc && ln -sf $(PWD)/ideavimrc ~/.ideavimrc
	[[ -f ~/.vimrc && ! -L ~/.vimrc ]]  && mv ~/.vimrc ~/.vimrc_back || rm -f ~/.vimrc
	[[ -f ~/.gvimrc && ! -L ~/.gvimrc ]]  && mv ~/.gvimrc ~/.gvimrc_back || rm -f ~/.gvimrc
	[[ ! -e ~/.SpaceVim.d || -L ~/.SpaceVim.d ]] && rm -f ~/.SpaceVim.d && ln -sf $(PWD)/SpaceVim.d ~/.SpaceVim.d
	[[ ! -e ~/.vim/after || -L ~/.vim/after ]] && rm -f ~/.vim/after && ln -sf $(PWD)/vim/after ~/.vim/

jedi:
	# jedi need to be installed to the python that compiled into vim
	# https://jedi.readthedocs.io/en/latest/docs/installation.html
ifeq ($(UNAME),Darwin)
	/usr/local/bin/pip3 install --upgrade jedi
endif

vim: spacevim
	pip install pyvim vim-vint

vim-venv:
	mkdir -p ~/venvs/vim && ln -sf $(PWD)/Pipfile.venv_vim ~/venvs/vim/Pipfile
	cd ~/venvs/vim && PIPENV_VENV_IN_PROJECT=1 pipenv install --dev

neovim: vim vim-venv
	pip install neovim


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
	[[ ! -e ~/.ammonite || -L ~/.ammonite ]] && rm -f ~/.ammonite && ln -sf $(PWD)/ammonite ~/.ammonite
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

fzf:
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
#  ## Python ##

pyenv:
	@echo "-- install [pyenv](https://github.com/pyenv/pyenv#installation)"
	./scripts/install_or_upgrade_pyenv.sh

pip: pyenv
	@echo "-- install python packages by calling pip_packages.sh"
	@eval "$(pyenv init -)" && ./scripts/pip_packages.sh

pre-commit:
	@echo "-- install pre-commit for this project."
	pre-commit install

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
