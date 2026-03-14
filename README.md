# nix-infra

NixOS configuration managing my desktop (hexolexo) and homelab server (vault) with deploy-rs deployments

**hexolexo** (desktop)
- Hyprland + Wayland
- Colemak layout with custom keyd bindings
- Development environment (Go, Rust, Nix, OpenTofu)
- Gaming (Steam, Prism Launcher)
- AMD GPU with ROCm

**vault** (server)
- Minecraft server
- Git server (soft-serve)
- Wireguard mesh node
- Auto-updates at 16:00 daily with reboot (I recommend disabling auto reboots if you run this yourself)
- And a handful of other services I've disabled for (mainly) security reasons

## Requirements

- NixOS 25.05+
- SSH access to server (for deploy-rs)
- Personal repo at `git@localgit/secrets.git` (So ideally you don't dox your IP on git)
```nix
{
    description = "IP addresses";
    outputs = {self}: {
        HomeIP = "1.2.3.4";
        ServerIP = "10.0.0.1"
        I2P_Port = 12345
    }
}
```

## ./rebuild.sh

Smart rebuild script that diffs changed paths to determine whether to rebuild the desktop, the server or both
then commits with the resulting generation number and stating which system changed.

## Screenshots

![Desktop](screenshots/working_desktop.png)
![Workflow](screenshots/background.png)
