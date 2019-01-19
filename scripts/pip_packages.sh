#!/usr/bin/env bash

set -x errexit

PIP_OPTS="--ignore-installed"

echo "-- pip self upgrade"
pip install ${PIP_OPTS} --upgrade pip

echo "-- pip install tools"
# flake8 builtin support - pyflakes, pycodestyle, mccabe
#  flake8-black           \
#  flake8-isort           \
#  flake8-commas          \
#  flake8-spellcheck      \
pip3 install ${PIP_OPTS} \
  docformatter           \
  black                  \
  flake8                 \
  flake8-bandit          \
  flake8-blind-except    \
  flake8-bugbear         \
  flake8-builtins        \
  flake8-chart           \
  flake8-colors          \
  flake8-comprehensions  \
  flake8-docstrings      \
  flake8-eradicate       \
  flake8-mutable         \
  flake8-mypy            \
  flake8-rst-docstrings  \
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
  PyAML                  \
  pygments               \
  pylama                 \
  pyvim                  \
  sqlparse               \
  thefuck                \
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
