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
          a = "a";
          b = "b";
          c = "c";
          d = "d";
          e = "e";
          f = "f";
          g = "g";
          h = "h";
          i = "i";
          j = "j";
          k = "k";
          l = "l";
          m = "m";
          n = "n";
          o = "o";
          p = "p";
          q = "q";
          r = "r";
          s = "s";
          t = "t";
          u = "u";
          v = "v";
          w = "w";
          x = "x";
          y = "y";
          z = "z";
        };
        # I just wanted to play UNBEATABLE man...
        "remap:toggle" = {}; # Marks remap as toggleable
      };
    };
  };
}
