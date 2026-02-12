{pkgs, ...}: {
  nixpkgs.config.android_sdk.accept_license = true;
  environment.systemPackages = with pkgs; [
    godotPackages_4_3.godot
  ];
}
