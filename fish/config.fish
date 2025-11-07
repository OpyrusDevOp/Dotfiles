function nvm
    bass source /usr/share/nvm/init-nvm.sh --no-use ';' nvm $argv
end

function zj -a session
    zellij attach $session
end

if status is-interactive
    # Initialize keychain for SSH key management
    # This will prompt for password once per session and cache it
    if type -q keychain
        eval (keychain --eval --quiet --agents ssh id_ed25519)
    end

    # Initialize NVM
    nvm use default

    # Clear screen and show system info
    clear
    fastfetch
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
