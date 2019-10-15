SHELL = /bin/bash

# sudo apt install vim git make

.PHONY: apt
apt:
	sudo apt update && sudo apt upgrade --assume-yes && sudo apt autoremove --assume-yes

.PHONY: python3
python3:
	sudo apt install python3 python3-pip
	pip3 install --user --upgrade --ignore-installed pip
	pip3 install --user --upgrade pipenv

.PHONY: pipenv
pipenv:
	pipenv install --dev
