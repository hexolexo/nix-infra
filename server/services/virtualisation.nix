{pkgs, ...}: {
  imports = [
    ../modules/virtual-networking.nix
  ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
    };
  };

  services.dnsmasq.enable = false;

  users.users.hexolexo = {
    extraGroups = ["libvirtd"];
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
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
    # Ansible
    ansible
    python3Packages.pywinrm # Required for Windows management
    python3Packages.requests-ntlm # For NTLM authentication
    python3Packages.requests-credssp # For CredSSP authentication
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
