-------------------
---  AUTOSTART  ---
-------------------

hl.on("hyprland.start", function()
    --- Required
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    hl.exec_cmd("uwsm app -- gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("uwsm app -- /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    hl.exec_cmd("uwsm app -- awww-daemon")
    hl.exec_cmd("sleep 0.3; ~/.config/bin/restore-wall.sh")

    hl.exec_cmd("uwsm app -- hypridle")
    hl.exec_cmd("uwsm app -- nwg-look -a")
    hl.exec_cmd("uwsm app -- wl-clip-persist --clipboard regular --write-timeout 1000 --selection-size-limit 2097152 --all-mime-type-regex '(?i)^(?!(?:image|audio|video|font|model)/|x-kde-passwordManagerHint).+'")

    hl.exec_cmd("uwsm app -- swaync -c ~/.config/swaync/config.json")
    hl.exec_cmd("uwsm app -- waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/styles.css")
    hl.exec_cmd("uwsm app -- vicinae server --replace")

    --- Recommended
    hl.exec_cmd("uwsm app -- nm-applet")
    hl.exec_cmd("uwsm app -- blueman-applet")
end)
