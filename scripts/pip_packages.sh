#!/usr/bin/env bash

set -x errexit

PIP_OPTS="--ignore-installed"

echo "-- pip self upgrade"
pip install ${PIP_OPTS} --upgrade pip

echo "-- pip install tools"
pip3 install ${PIP_OPTS} \
  black                  \
  docformatter           \
  eradicate              \
  httpie                 \
  ipython                \
  isort                  \
  jupyter                \
  jupyterlab             \
  neovim                 \
  pipenv                 \
  poetry                 \
  pre-commit             \
  pssh                   \
  pyaml                  \
  pycodestyle            \
  pyflakes               \
  pygments               \
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
  cattrs                 \
  chartify               \
  click                  \
  pandas                 \
  pexpect                \
  PyYAML                 \
  seaborn                \
  tabulate               \
  toml                   \
  toolz                  \
  tqdm                   \
  vega_datasets          \
  # END
