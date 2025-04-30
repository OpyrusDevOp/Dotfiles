function nvm
    bass source /usr/share/nvm/init-nvm.sh --no-use ';' nvm $argv
end

function zj -a session
    zellij attach $session
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    keychain --eval /home/opyrusdev/.ssh/id_ed25519 | source
    nvm use default
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[ -f /home/opyrusdev/.nvm/versions/node/v22.14.0/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.fish ]; and . /home/opyrusdev/.nvm/versions/node/v22.14.0/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.fish

