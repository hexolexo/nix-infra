hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
-- Might need to use this one -- monitor = eDP-1,preferred,auto,1.333

local mainMod = "SUPER"

local terminal    = "alacritty"
local fileManager = "dolphin"
local menu        = "pkill fuzzel || fuzzel --show drun"

-- $scripts = $HOME/.config/hypr/scripts/

hl.on("hyprland.start", function () 
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaybg -i $HOME/Pictures/Backgrounds/Cloudsnight.jpg")
    -- hl.exec_cmd("dunst")
    hl.exec_cmd("clipse -listen")
 end)

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")


hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")


