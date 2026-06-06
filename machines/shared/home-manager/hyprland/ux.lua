-- ── GENERAL + DECORATION + LAYOUT ──────────────────────────────────────

hl.config({
    general = {
        gaps_in             = 10,
        gaps_out            = 0,
        border_size         = 2,
        col = {
            -- gradient: colour stops then angle
            active_border   = { colors = {"rgba(B0A4FFFF)", "rgba(B0A4FF00)"}, angle = 45 },
            inactive_border = "rgba(00000000)",
        },
        layout              = "dwindle",
        allow_tearing       = true,
        resize_on_border    = true,
        extend_border_grab_area = 15,
    },
    decoration = {
        rounding         = 10,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        -- shadow disabled in original; omit or set shadow = { enabled = false }
        blur = {
            enabled           = true,
            size              = 7,
            passes            = 2,
            ignore_opacity    = true,
            new_optimizations = true,
            popups            = true,
        },
    },
    dwindle = {
        preserve_split = true,
        force_split    = 2,
    },
    cursor = {
        no_warps = false,
    },
    master = {
        drop_at_cursor = false,
    },
    misc = {
        force_default_wallpaper = 1,
        disable_hyprland_logo   = true,
    },
    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",
        follow_mouse = 1,
        accel_profile = "flat",
        sensitivity  = 0.5,
        touchpad = {
            natural_scroll = true,
            -- WARN: disable_while_typing not set; add if you need it for games
        },
    },
})


-- ── ANIMATIONS ──────────────────────────────────────────────────────────

-- bezier name, then the four control points
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default",   style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5,  bezier = "default" })
-- slidevert was commented out; just swap bezier/style here if you want it back


-- ── GESTURE ─────────────────────────────────────────────────────────────

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })


-- ── WINDOW RULES ────────────────────────────────────────────────────────

-- opacity: "active inactive" as a string
hl.window_rule({
    match   = { class = "Alacritty" },
    -- WARN: class match is exact string / RE2 regex; drop the ^()$ anchors, they're implicit
    opacity = "0.8 override 0.8 override",
})

hl.window_rule({
    match        = { class = "clipse" },
    float        = true,
    size         = "622 652",
    stay_focused = true,
})
