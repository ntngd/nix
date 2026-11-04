# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "knix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enables the dconf D-Bus service daemon system-wide
  programs.dconf.enable = true;

  # Ensure xdg-desktop-portal is enabled so GTK/Qt apps receive settings
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  # 3. Dedicated Steam module
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;     # Optional: ports for Steam Remote Play
    dedicatedServer.openFirewall = true; # Optional: ports for local server hosting
    gamescopeSession.enable = true;      # Optional: gamescope micro-compositor session
    extraCompatPackages = with pkgs; [
      proton-ge-bin                     # Pull GE-Proton releases automatically
    ];
  };

  # 4. Optional: Gaming performance helpers
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;


  programs.java = {
    enable = true;
    package = pkgs.jdk;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # i18n.extraLocaleSettings = {
  #   LC_ADDRESS = "en_US";
  #   LC_IDENTIFICATION = "en_US";
  #   LC_MEASUREMENT = "en_US";
  #   LC_MONETARY = "en_US";
  #   LC_NAME = "en_US";
  #   LC_NUMERIC = "en_US";
  #   LC_PAPER = "en_US";
  #   LC_TELEPHONE = "en_US";
  #   LC_TIME = "en_US";
  # };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."ntngd" = {
    isNormalUser = true;
    description = "ntngd";
    extraGroups = [ "networkmanager" "wheel" "nordvpn" "docker"];
    packages = with pkgs; [];
  };

  services.greetd = {
    enable = true;
    settings = {
      # Launches tuigreet and defaults the launch command to mango
      default_session = {
	command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd mango";
	user = "greeter";
      };

      # Optional: bypass password prompt on first boot (auto-login)
      initial_session = {
         command = "mango";
         user = "ntngd";
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.mango.enable = true;

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["ntngd"];
  };

  programs._1password = {
    enable = true;
  };

  security.polkit.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    fuzzel
    waybar
    wl-clipboard
    mako
    wlr-randr
    inputs.mangobar.packages.${pkgs.system}.default
    #hyprpolkitagent
    #inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    swaybg
    mangohud       # Performance & FPS overlay
    steam-run      # FHS wrapper to run arbitrary standalone binaries
    pamixer
    playerctl
    pavucontrol
    lxqt.lxqt-policykit
    bluez
    bluez-tools
    emacs
    coreutils
    emacsPackages.pbcopy
    emacsPackages.vterm
    libvterm
    libtool
    gcc
    glibc
    libcxx
    gdb
    cmake
    gnumake
    libgcc
    #dunst #notifications
    go
    wget
  ];

  #programs.git = {
  #  enable = true;
  #  config = {
  #    init.defaultBranch = "main";
  #  };
  #};


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.nordvpn = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall.checkReversePath = "loose";
  services.resolved.enable = true;

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
