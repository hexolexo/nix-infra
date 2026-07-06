{pkgs, ...}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
    };
    podman = {
      enable = true;
      dockerCompat = true; # makes podman respond to docker:// labels
    };
  };

  services.dnsmasq.enable = false;

  users.users.hexolexo = {
    extraGroups = ["libvirtd"];
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    distrobox
    spice
    spice-gtk
    spice-protocol
    cdrkit
    dosfstools
    opentofu
    libxslt # tofu window xml dependency
    virtio-win
    win-spice
    bridge-utils
    nftables
  ];

  # Ensure proper service ordering
  systemd.services.libvirtd = {
    path = with pkgs; [
      qemu_kvm
      nftables
      bridge-utils
    ];
  };
}
