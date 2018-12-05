SHELL=/bin/bash

UNAME := $(shell uname -s)
ifeq ($(UNAME),Linux)
    os_install = sudo apt-get install
endif
ifeq ($(UNAME),Darwin)
    os_install = brew install
endif

.PHONY: all boostrap coursier sdkman pyenv ammonite
all: bootstrap fonts coursier sdkman pyenv

bootstrap:
	@for tool in git curl; do \
	  if ! command -v $${tool} &>/dev/null; then \
	  $(os_install) $${tool}; \
	fi; \
	done

fonts: bootstrap
	@echo "-- download & install [https://nerdfonts.com/](Nerd Fonts)"
	@[[ -e ~/.fonts/"Sauce Code Pro Nerd Font Complete Mono.ttf" ]] \
	  || ( mkdir -p ~/.fonts && cd ~/.fonts \
	  && curl --remote-name --location https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/SourceCodePro.zip \
	  && unzip SourceCodePro.zip && rm -f SourceCodePro.zip )

# -----------------------------------------------------------------------------
sdkman: bootstrap
	@echo "-- install [https://sdkman.io/install](sdkman)"
	@# XXX: sdkman is a shell function, and not initialized in make env.
	@if [[ ! -d ~/.sdkman ]]; then \
	  curl -s "https://get.sdkman.io" | bash; \
	fi

coursier: bootstrap
	@echo "-- install [https://coursier.github.io/coursier/1.1.0-SNAPSHOT/docs/quick-start-cli](coursier)"
	@if ! command -v coursier &>/dev/null; then \
	  curl -L -o coursier https://git.io/coursier && chmod +x coursier; \
	  mkdir -p ~/.local/bin; \
	  mv coursier ~/.local/bin; \
	fi

ammonite: sdkman coursier
	@echo "-- install [http://ammonite.io/#Ammonite-REPL](ammonite)"
	@source $${HOME}/.sdkman/bin/sdkman-init.sh \
	  && sdk install java 8.0.191-oracle \
	  && sdk install scala 2.12.7 \
	  && sdk install gradle 4.10.2 \
	  && cp amm ~/bin \
	  && amm --help


# -----------------------------------------------------------------------------

fzf:
	@git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf


# -----------------------------------------------------------------------------
pyenv:	bootstrap
	@echo "-- insall [https://github.com/pyenv/pyenv#installation](pyenv)"
	@if ! command -v pyenv &>/dev/null; then \
	  git clone https://github.com/pyenv/pyenv.git ~/.pyenv; \
	fi

pip: pyenv
	@eval "$(pyenv init -)" \
	  && echo "-- pip self upgrade" \
	  && pip install --user --upgrade pip \
	  && echo "-- pip install tools" \
	  && pip3 install --user --upgrade \
	    black \
	    eradicate \
	    httpie \
	    ipython \
	    isort \
	    jedi \
	    jupyter \
	    neovim \
	    pipenv \
	    pycodestyle \
	    pylama \
	    sqlparse \
	    vim-vint \
	    vint \
	&& echo "-- pip install libs" \
	&& pip3 install --user --upgrade \
	    PyYAML \
	    absl-py \
	    attrs \
	    chartify \
	    click \
	    pandas \
	    pexpect \
	    pycodestyle \
	    seaborn \
	    six \
	    sqlparse \
	    tabulate \
	    toml \
	    tqdm \
	  # END
