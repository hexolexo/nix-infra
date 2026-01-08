{
  config,
  pkgs,
  nur,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.zen-browser;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      settings = {
        "browser.startup.homepage" = "about:home";
        "browser.search.defaultenginename" = "DuckDuckGo";
        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
        #  WARN: Zen might use different pref names than Firefox
      };

      # Extensions via nur.repos.rycee.firefox-addons
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        adnauseam
      ];
    };
    policies.SearchEngines.Default = "DuckDuckGo";
  };
}
