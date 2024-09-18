{pkgs, ...}: {
  imports = [./hardware-configuration.nix ../../modules/brightness.nix ../../users/flavio.nix ../../modules/shutdown.nix ../../modules/docker.nix];

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

  networking.firewall.allowedTCPPorts = [2222 8096 8920 137 138 139 445];

  system.stateVersion = "24.05";
}
