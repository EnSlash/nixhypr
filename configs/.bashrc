alias confgw='cd ~/WORK/Config/ && ./get-gpg.sh && ./unpack-gpg.sh gpg/asa-5520-cp.tar.gpg && ./unpack-gpg.sh gpg/dell-sw-1.tar.gpg && ./unpack-gpg.sh gpg/dell-sw-2.tar.gpg && ./unpack-gpg.sh gpg/esr1.tar.gpg && ./unpack-gpg.sh gpg/esr2.tar.gpg'
alias s='sudo'
alias hgg='hg annotate'
alias hgl='hg log'
alias c='clear'
alias upg='sudo nixos-rebuild switch'
alias l="exa -lag"
alias kb="setxkbmap -model pc105 -layout us,ru -option grp:alt_shift_toggle"



# Для гибридной графики
export __GL_THREADED_OPTIMIZATIONS=1

if [[ $- == *i* ]]; then
    setxkbmap -model pc105 -layout us,ru -option grp:alt_shift_toggle
    neofetch
fi

export PATH="$HOME/.local/bin:$PATH"

