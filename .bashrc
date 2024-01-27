#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# alias ls='ls --color=auto'
# PS1='[\u@\h \W]\$ '
set -o vi
alias sudo="doas"
export OPENAI_KEY=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
complete -cf doas
fortune | cowsay
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit

#autostartx
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
