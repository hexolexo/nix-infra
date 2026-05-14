{...}: {
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "http://10.0.0.1:2586";
      listen-http = ":2586";
      auth-default-access = "deny-all";
      auth-file = "/var/lib/ntfy-sh/user.db";
    };
  };
}
