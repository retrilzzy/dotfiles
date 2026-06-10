-------------------
---    RULES    ---
-------------------

-- https://wiki.hyprland.org/Configuring/Window-Rules/
-- https://wiki.hyprland.org/Configuring/Workspace-Rules/


--- Floating windows
-- Calculator
hl.window_rule({
    name = "calculator",
    match = { class = "^(org.gnome.Calculator)$" },
    float = true,
    size = { 400, 500 },
})

-- General floating windows
local FLOAT_CLASSES = "^(org.pulseaudio.pavucontrol|nm-connection-editor"
    .. "|blueman-manager|nekobox|waypaper)$"
hl.window_rule({
    name = "float-classes",
    match = { class = FLOAT_CLASSES },
    center = true,
    float = true,
    size = { "(monitor_w*0.5)", "(monitor_h*0.5)" },
})


--- Dialog windows
local DIALOG_TITLES = "^(Open Files?|Pick Files?|Choose Files|Choose a file"
    .. "|Select a File|Choose wallpaper|Open Folders?|Add Folders?( to Workspace)?"
    .. "|Save As|Library|File Upload|.*wants to (save|open))$"
hl.window_rule({
    name = "dialogs",
    match = { title = DIALOG_TITLES },
    center = true,
    float = true,
    size = { "(monitor_w*0.5)", "(monitor_h*0.5)" },
})


--- Picture-in-Picture
local PiP = "^(Picture.?in.?[Pp]icture)$"
hl.window_rule({
    name = "picture-in-picture",
    match = { title = PiP },
    border_size = 0,
    float = true,
    keep_aspect_ratio = true,
    move = { "(monitor_w*0.71)", "(monitor_h*0.13)" },
    opacity = "1.0 1.0",
    pin = true,
    size = { "(monitor_w*0.25)", "(monitor_h*0.25)" },
})


--- Opacity 100%
local OPAQUE_CLASSES = "^(libreoffice|ONLYOFFICE|qemu|vlc"
    .. "|com.obsproject.Studio|imv|org.gnome.NautilusPreviewer)$"
hl.window_rule({
    name = "opaque-apps",
    match = { class = OPAQUE_CLASSES },
    opaque = true,
})


--- App-specific rules
-- KDE Connect
local KDE_CONNECT = "org.kde.kdeconnect.daemon"
hl.window_rule({
    name = "kde-connect",
    match = { class = KDE_CONNECT },
    float = true,
    no_focus = true,
    no_initial_focus = true,
})
-- KDE Connect "Presentation remote"
-- hl.window_rule({
--     name = "kde-connect-presentation",
--     match = { class = KDE_CONNECT },
--     border_size = 0,
--     move = { 0, 0 },
--     no_blur = true,
--     no_shadow = true,
--     opacity = "1.0",
--     pin = true,
--     size = { "(monitor_w*1)", "(monitor_h*1)" },
--     suppress_event = "fullscreen",
-- })

-- Steam
hl.window_rule({
    name = "steam",
    match = { class = "steam", initial_title = "Steam" },
    float = false,
})

hl.window_rule({
    name = "steam-settings",
    match = { title = "^(Steam Settings)$" },
    center = true,
    float = true,
})

hl.window_rule({
    name = "steam-shutdown",
    match = { class = "steam", title = "^(Shutdown)$" },
    center = true,
    float = true,
})


--- Workspace-specific rules
-- Games
hl.window_rule({
    name = "games-workspace",
    match = { workspace = 8 },
    no_blur = true,
    no_shadow = true,
    opaque = true,
})


--- Technical fixes & overrides
-- Tearing
hl.window_rule({
    name = "tearing-exe",
    match = { title = ".*\\.exe" },
    immediate = true,
})
hl.window_rule({
    name = "tearing-minecraft",
    match = { title = ".*minecraft.*" },
    immediate = true,
})
hl.window_rule({
    name = "tearing-steam",
    match = { class = "^(steam_app).*" },
    immediate = true,
})

-- Ignore maximize requests from apps
hl.window_rule({
    name = "ignore-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name = "xwayland-drag-fix",
    match = {
        class = "^$",
        title = "^$",
        float = true,
        fullscreen = false,
        pin = false,
        xwayland = true,
    },
    no_focus = true,
})

-- Fix blur around XWayland windows
-- Variant 1
hl.window_rule({
    name = "xwayland-blur-fix",
    match = { class = "^()$", title = "^()$" },
    no_blur = true,
    opacity = "0.98 override",
})
-- Variant 2
-- hl.window_rule({
--     name = "xwayland-blur-fix-alt",
--     match = { float = true, xwayland = true },
--     no_blur = true,
--     opacity = "0.98 override",
-- })


--- Screen Sharing
-- No Screen Share for Authentication Window and KeePassXC
hl.window_rule({
    name = "no-screen-share-apps",
    match = { class = "^(polkit-gnome-authentication-agent-1|org.keepassxc.KeePassXC)$" },
    no_screen_share = true,
})

-- NoScreenShare for SwayNC
-- hl.layer_rule({ match = { namespace = "^(swaync-control-center|swaync-notification-window)$" }, no_screen_share = true })

-- NoScreenShare (~/.config/bin/toggle-noscreenshare.sh)
-- hl.layer_rule({ match = { namespace = "^(.*)$" }, no_screen_share = true })
-- hl.window_rule({ match = { initial_class = "^(.*)$" }, no_screen_share = true })
