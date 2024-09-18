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

  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.users.gustavo = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  users.users.flavio = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    wpa_supplicant
    git
    # No borrar
    brightnessctl
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  networking.firewall.allowedTCPPorts = [2222 8096 8920 137 138 139 445];

  system.stateVersion = "24.05";
}
