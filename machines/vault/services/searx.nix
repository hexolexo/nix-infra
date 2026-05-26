{...}: {
  services.searx = {
    enable = true;
    redisCreateLocally = true;
    settings = {
      server = {
        secret_key = "TemporaryKeyBecauseThisIsAPrivateServer";
        limiter = false;
        bind_address = "10.0.0.1";
        port = 8080;
      };
      search.formats = ["html" "json"];
    };
  };
}
