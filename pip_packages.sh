#!/usr/bin/env bash

set -x errexit

PIP_OPTS="--ignore-installed"

echo "-- pip self upgrade"
pip install ${PIP_OPTS} --upgrade pip

echo "-- pip install tools"
pip3 install ${PIP_OPTS} \
  black                  \
  eradicate              \
  httpie                 \
  ipython                \
  isort                  \
  jedi                   \
  jupyter                \
  jupyterlab             \
  neovim                 \
  pipenv                 \
  poetry                 \
  pre-commit             \
  pycodestyle            \
  pyflakes               \
  pylama                 \
  pyvim                  \
  sqlparse               \
  vim-vint               \
  vint                   \
  # END

echo "-- pip install libs"
pip3 install ${PIP_OPTS} \
  absl-py                \
  altair                 \
  attrs                  \
  chartify               \
  click                  \
  pandas                 \
  pexpect                \
  PyYAML                 \
  seaborn                \
  six                    \
  tabulate               \
  toml                   \
  toolz                  \
  tqdm                   \
  vega_datasets          \
  # END
