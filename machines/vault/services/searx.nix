{lib, ...}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "open-webui"
    ];
  services.open-webui = {
    enable = true;
    port = 8080;
    environment = {
      OLLAMA_BASE_URL = "http://10.0.0.8:11434";
      ENABLE_WEB_SEARCH = "True";
      WEB_SEARCH_ENGINE = "searxng";
      SEARXNG_QUERY_URL = "http://127.0.0.1:8088/search?q=<query>";
    };
  };
  services.searx = {
    enable = true;
    redisCreateLocally = true;
    settings = {
      server = {
        secret_key = "TemporaryKeyBecauseThisIsAPrivateServer";
        limiter = false;
        bind_address = "10.0.0.1";
        port = 8088;
      };
      search.formats = ["html" "json"];
    };
  };
}
