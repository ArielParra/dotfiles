#!/bin/env sh

rm ~/.vimrc
rm ~/.xinitrc
rm ~/.bashrc

ln -s $PWD/.vimrc ~/
ln -s $PWD/.xinitrc ~/
ln -s $PWD/.bashrc ~/

