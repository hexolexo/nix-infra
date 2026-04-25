{...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "FiraCode Nerd Font";
      font-size = 12;
      cursor-style = "bar";
      mouse-hide-while-typing = true;
      term = "xterm-256color";

      background = "#1E1E2E";
      foreground = "#CDD6F4";
    };
  };
}
