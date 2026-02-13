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
    libva
    libva-utils
    mesa
    mesa.drivers
    libva
    jdk17
  ];
  services.udev.extraRules = ''
    # Valve HID devices (Index, Vive, etc)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0bb4", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0bb4", MODE="0666", TAG+="uaccess"

    # Meta/Oculus headsets
    SUBSYSTEM=="usb", ATTR{idVendor}=="2833", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", MODE="0666", GROUP="plugdev"
  '';
}
