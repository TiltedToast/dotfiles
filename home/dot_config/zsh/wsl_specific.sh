export SURFSHARK_ADAPTERS=(eth0 eth2)

for adapter in ${SURFSHARK_ADAPTERS[@]}; do
    ip a | rg $adapter &> /dev/null && sudo ip link set dev $adapter mtu 1350 &> /dev/null
done

command -v dbus-launch > /dev/null && export $(dbus-launch)
export GALLIUM_DRIVER=d3d12
export LIBVA_DRIVER_NAME=d3d12
export VDPAU_DRIVER=d3d12

export GTK_THEME=Adwaita-dark

eval "$(wsl2-ssh-agent)"

if [[ ! -e ~/.local/bin/code ]]; then
    ln -s "/mnt/c/Users/tim/AppData/Local/Programs/Microsoft VS Code/bin/code" ~/.local/bin/code
fi

if [[ ! -e ~/.local/bin/cmd.exe ]]; then
    ln -s "/mnt/c/Windows/System32/cmd.exe" ~/.local/bin/cmd.exe
fi

if [[ ! -e ~/.local/bin/op-ssh-sign ]]; then
    ln -s "/mnt/c/Users/tim/AppData/Local/1Password/app/8/op-ssh-sign-wsl" ~/.local/bin/op-ssh-sign
fi

alias explorer.exe="/mnt/c/windows/explorer.exe"
