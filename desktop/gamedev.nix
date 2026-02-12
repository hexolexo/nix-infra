{pkgs, ...}: {
  nixpkgs.config.android_sdk.accept_license = true;
  environment.systemPackages = with pkgs; [
    godotPackages_4_4.godot
    pkgsRocm.blender
    android-studio
    android-tools
    androidenv.androidPkgs.androidsdk
    androidenv.androidPkgs.emulator
    androidenv.androidPkgs.ndk-bundle
    jdk
  ];
}
