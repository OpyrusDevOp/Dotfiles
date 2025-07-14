function nvm
    bass source /usr/share/nvm/init-nvm.sh --no-use ';' nvm $argv
end

function zj -a session
    zellij attach $session
end

function start_ssh_agent
    for line in (keychain --eval ~/.ssh/id_ed25519)
        if string match -qr '^([A-Z_]+)=' -- $line
            set var (string split '=' (string split ';' $line)[1])[1]
            set val (string split '=' (string split ';' $line)[1])[2]
            set -gx $var $val
        end
    end
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    # keychain --eval /home/opyrusdev/.ssh/id_ed25519 | source

    start_ssh_agent
    nvm use default
    clear
    fastfetch
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
