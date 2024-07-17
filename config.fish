if status is-interactive

    # set --global hydro_multiline true
    abbr -a b --function projectdo_build
    abbr -a r --function projectdo_run
    abbr -a t --function projectdo_test

    abbr -a n nvim

    abbr -a chp bluetoothctl connect E8:EE:CC:2A:A4:59

    abbr -a c clear 
    abbr -a l exa -lah
    atuin init fish | source
end

# Created by `pipx` on 2024-05-08 17:36:51
set PATH $PATH /home/vmedv/.local/bin
