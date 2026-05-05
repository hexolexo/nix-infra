{pkgs, ...}: let
  convertFiletypes = ".doc .docx .odt application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document";
in {
  systemd.services.paperless-consumer.environment = {
    PAPERLESS_CONVERT_BINARY = "${pkgs.libreoffice}/bin/libreoffice";
    PAPERLESS_CONVERT_FILETYPES = convertFiletypes;
    PAPERLESS_OCR_LANGUAGE = "eng";
    PAPERLESS_TASK_WORKERS = "16";
    PAPERLESS_THREADS_PER_WORKER = "2";
  };

  systemd.services.paperless-scheduler.environment = {
    PAPERLESS_OCR_LANGUAGE = "eng";
  };

  systemd.services.paperless-web.environment = {
    PAPERLESS_OCR_LANGUAGE = "eng";
  };
  services.paperless = {
    enable = true;
    address = "10.0.0.1";
    port = 58080;
    settings = {
      PAPERLESS_OCR_LANGUAGE = "eng";
      #PAPERLESS_CONVERT_BINARY = "${pkgs.libreoffice}/bin/libreoffice";
      #PAPERLESS_CONVERT_TMPDIR = "/tmp";
      #PAPERLESS_CONVERT_FILETYPES = ".doc .docx .odt application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document";
      PAPERLESS_TASK_WORKERS = "16";
      PAPERLESS_THREADS_PER_WORKER = "2";
    };
  };
  environment.systemPackages = with pkgs; [
    libreoffice
    ghostscript
    unpaper
    optipng
    tesseract
    qpdf
  ];
  systemd.services.paperless-scheduler.after = ["var-lib-paperless.mount"];
  systemd.services.paperless-consumer.after = ["var-lib-paperless.mount"];
  systemd.services.paperless-web.after = ["var-lib-paperless.mount"];
  networking.firewall.allowedTCPPorts = [58080];
}
