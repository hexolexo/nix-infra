{pkgs, ...}: {
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings = {
        main = {
          capslock = "backspace";
          backspace = "noop";
          rightalt = "esc";
          esc = "noop";
          rightshift = "overload(toggle_layer, rightshift)";

          # QWERTY to Colemak (This is going to be a mistake)
          # q = "q";
          # w = "w";
          e = "f";
          r = "p";
          t = "g";
          y = "j";
          u = "l";
          i = "u";
          o = "y";
          p = ";";
          #a = "a";
          s = "r";
          d = "s";
          f = "t";
          g = "d";
          # h = "h";
          j = "n";
          k = "e";
          l = "i";
          ";" = "o";
          # z = "z";
          # x = "x";
          # c = "c";
          # v = "v";
          # b = "b";
          n = "k";
          # m = "m";
        };
        toggle_layer = {
          leftshift = "toggle(remap)"; #  HACK: What the fuck have I created
        };
        remap = {
          w = "w";
          a = "a";
          s = "s";
          d = "d";
          q = "q";
          e = "e";
          f = "f";
          r = "r";
          # What kind of autism *is* this
          j = "f"; # n -> f
          i = "d"; # u -> d
        };
        # I just wanted to play UNBEATABLE man...
        "remap:toggle" = {}; # Marks remap as toggleable
      };
    };
  };
}
