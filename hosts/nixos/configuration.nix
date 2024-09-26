{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/brightness.nix
    ../../users/flavio/flavio.nix
    ../../users/mathew.nix
    # ../../modules/shutdown.nix
    ../../modules/podman.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.users.gustavo = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    wpa_supplicant
    git
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  # networking.firewall.allowedTCPPorts = [2222 8096 8920 137 138 139 445];
  networking.interfaces = {
    wakeUp = {
      wakeOnLan.enable = true;
      ipv4 = {
        addresses = [
          {
            address = "190.148.223.41";
            prefixLength = 32;
          }
        ];
      };
    };
  };

  system.stateVersion = "24.05";
}
