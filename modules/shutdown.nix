{pkgs, ...}: {
  systemd.services.scheduled-shutdown = {
    description = "Se apaga el server a las [21:44]";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/shutdown -h 21:44";
    };
  };
}
