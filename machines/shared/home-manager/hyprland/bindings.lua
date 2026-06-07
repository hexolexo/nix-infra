local mainMod  = "SUPER"
local terminal = "alacritty"
local menu     = "pkill fuzzel || fuzzel --show drun"
local scripts  = os.getenv("HOME") .. "/.config/hypr/scripts"

-- ── TERMINAL ────────────────────────────────────────────────────────────

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(terminal .. " -e ssh server"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd(terminal .. " -e ssh root@server"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(terminal .. " -e ssh -t server '$HOME/go/bin/vmgr'"))
-- WARN: $HOME above is the remote shell's HOME, not local — single quotes intentional


-- ── APPLICATIONS ────────────────────────────────────────────────────────

hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd(
    "swaylock --screenshots --clock --effect-blur 20x10 --indicator" ..
    " --ring-color cba6f7 --inside-color 1e1e2e --key-hl-color fab387" ..
    " --text-ver-color cba6f7 --layout-text-color cba6f7"
))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("alacritty --class clipse -e clipse"))


-- ── FAN CONTROL ─────────────────────────────────────────────────────────
-- WARN: sudo in exec_cmd requires NOPASSWD in sudoers or it silently fails

hl.bind(mainMod .. " + 1", hl.dsp.exec_cmd("sudo systemctl start fanAutoControl"), { locked = true })
hl.bind(mainMod .. " + 2", hl.dsp.exec_cmd("sudo systemctl start fanQuiet"),       { locked = true })
hl.bind(mainMod .. " + 3", hl.dsp.exec_cmd("sudo systemctl start fanMax"),          { locked = true })


-- ── LID SWITCH ──────────────────────────────────────────────────────────

hl.bind("switch:on:Lid Switch",  hl.dsp.dpms({ monitor = "all", status = "off" }), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.dpms({ monitor = "all", status = "on"  }), { locked = true })
-- WARN: old config shelled out to hyprctl dispatch dpms — use native dispatcher instead


-- ── AUDIO ────────────────────────────────────────────────────────────────

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { repeating = true, locked = true })
hl.bind(mainMod .. " + XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 1"), { repeating = true, locked = true })
hl.bind(mainMod .. " + XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 1"), { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer --toggle-mute"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("mpc prev"),    { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("mpc toggle"),  { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("mpc next"),    { locked = true })


-- ── BRIGHTNESS ──────────────────────────────────────────────────────────

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })


-- ── SCRIPTS ─────────────────────────────────────────────────────────────

hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd("bash " .. scripts .. "/addPlaylist.sh"))
hl.bind(mainMod .. " + Print",     hl.dsp.exec_cmd("bash " .. scripts .. "/screenshot.sh 0"))  -- active window
hl.bind("Print",                   hl.dsp.exec_cmd("bash " .. scripts .. "/screenshot.sh 1"))  -- fullscreen
hl.bind(mainMod .. " + b",         hl.dsp.exec_cmd("bash " .. scripts .. "/bluetooth.sh"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(terminal .. " -e bash " .. scripts .. "/backup.sh"))


-- ── HYPRLAND ─────────────────────────────────────────────────────────────

hl.bind(mainMod .. " + y",         hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + l",         hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + SHIFT + y", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + Q",         hl.dsp.window.kill())
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + M",         hl.dsp.exec_cmd("uwsm stop"))
-- WARN: original used exit dispatcher — unsafe with uwsm, use uwsm stop instead
hl.bind(mainMod .. " + Space",     hl.dsp.window.float({ action = "toggle" }))


-- ── FOCUS (colemak hjkl = n/e/i/o) ──────────────────────────────────────

hl.bind(mainMod .. " + n",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + o", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + e",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + i",  hl.dsp.focus({ direction = "down" }))

-- HACK: resize via resizeactive dispatcher — no native hl.dsp.window.resize direction API yet
hl.bind(mainMod .. " + ALT + n", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -30 0"))
hl.bind(mainMod .. " + ALT + e", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -30"))
hl.bind(mainMod .. " + ALT + i", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 30"))
hl.bind(mainMod .. " + ALT + o", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 30 0"))
-- NOTE: original had a typo "30 00" on the last one, corrected to "30 0"


-- ── SPECIAL WORKSPACE ────────────────────────────────────────────────────

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))


-- ── MOUSE ────────────────────────────────────────────────────────────────

-- hl.bind(mainMod .. " + mouse:272", hl.dsp.window.move(), { mouse = true })
