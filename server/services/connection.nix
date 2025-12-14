{pkgs, ...}:
#let
#secrets = import ./../secrets.nix;
#in
{
  environment.systemPackages = with pkgs; [
    borgbackup
  ];
  services = {
    openssh = {
      enable = true;
      ports = [6000];
      settings.PasswordAuthentication = true;
    };
    fail2ban.enable = true;
  };
  networking = {
    firewall.allowedTCPPorts = [
      6000
    ];
  };
}
