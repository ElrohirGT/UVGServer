{pkgs, ...}: {
  systemd.services.brightless = {
    description = "Le baja todo el brillo a la laptop";
    after = ["display-manager.service" "multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.brightnessctl}/bin/brightnessctl s 100%-";
    };
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
