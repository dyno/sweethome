#!/usr/bin/env bash

# https://stackoverflow.com/questions/25288194/dont-display-pushd-popd-stack-across-several-bash-scripts-quiet-pushd-popd
function pushd() {
  command pushd "$@" >/dev/null
}

function popd() {
  command popd "$@" >/dev/null
}

# https://github.com/pyenv/pyenv#installation
PYENV_ROOT=${PYENV_ROOT:-"${HOME}/.pyenv"}

set -o xtrace

if [[ -d "${PYENV_ROOT}" ]]; then
  # switching to git install, .pyenv may already exist and pyenv-installer will skip it.
  # so we manually initialize it following the installation instruction.
  pushd ${PYENV_ROOT}
  if [[ ! -d .git ]]; then
    # https://stackoverflow.com/questions/2411031/how-do-i-clone-into-a-non-empty-directory
    git clone --bare https://github.com/pyenv/pyenv.git .git
    git config --local --unset core.bare
  fi
  git fetch --all
  git reset --hard master
  popd
else
  # https://stackoverflow.com/questions/7373752/how-do-i-get-curl-to-not-show-the-progress-bar
  curl --show-error --location \
    https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
fi

PYENV_VIRTUALENV_DIR=${PYENV_ROOT}/plugins/pyenv-virtualenv
[[ ! -d ${PYENV_VIRTUALENV_DIR} ]] && git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
pushd ${PYENV_VIRTUALENV_DIR}
git fetch --all
git reset --hard master
popd

# XXX: https://github.com/pypa/pipenv/issues/3224
# pyenv global 3.6.7
# ~/.pyenv/version
