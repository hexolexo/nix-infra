{
  nix-minecraft,
  pkgs,
  ...
}: let
  inherit (nix-minecraft.legacyPackages.${pkgs.system}) fetchModrinth;
in {
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
  };

  # HACK: exporting mod groups through _module.args so servers can reference them
  # without re-importing nix-minecraft themselves
  _module.args.modGroups = {
    performance = [
      (fetchModrinth {
        projectId = "gvQqBUqZ";
        version = "iEcXOkz4";
      }) # lithium
      (fetchModrinth {
        projectId = "uXXizFIs";
        version = "unerR5MN";
      }) # ferritecore
      (fetchModrinth {
        projectId = "fQEb0iXm";
        version = "jiDwS0W1";
      }) # krypton
    ];
    create = [
      (fetchModrinth {
        projectId = "Xbc0uyRg";
        version = "HAqwA6X1";
      }) # create-fabric
      (fetchModrinth {
        projectId = "ZzjhlDgM";
        version = "yMgmXIuq";
      }) # steam-n-rails
    ];
    combat = [
      (fetchModrinth {
        projectId = "5sy6g3kz";
        version = "OtwNg4r4";
      }) # bettercombat
      (fetchModrinth {
        projectId = "L6jvzao4";
        version = "dRyyKuze";
      }) # epic-knight
    ];
  };
}
