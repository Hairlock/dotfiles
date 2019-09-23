# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.gc.automatic = true;
  nix.gc.dates = "22:00";

  nixpkgs.config.allowUnfree = true;
  environment.variables.EDITOR = "nvim";

  virtualisation.docker.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.enableIPv6 = false;
  networking.networkmanager.packages = [ pkgs.networkmanager_openvpn ];
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  boot.initrd.luks.devices = [
   {
    name = "root";
    device = "/dev/sda2";
    preLVM = true;
   }
  ];

  nix.binaryCaches = [
    "https://cache.nixos.org"
  ];

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  hardware.brightnessctl.enable = true;

  services.cron = {
    enable = true;
    # systemCronJobs = [
    #   "@reboot /home/yannick/scripts/xkeywatch >/dev/null 2>&1"
    # ];
  };


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain;
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  fonts.fonts = with pkgs; [
    # noto-fonts
    noto-fonts-cjk
    inconsolata
    # emojione
    # noto-fonts-emoji
    # liberation_ttf
    # fira-code
    # fira-code-symbols
    # mplus-outline-fonts
    # dina-font
    # proggyfonts
  ];

  # Set your time zone.
  time.timeZone = "Europe/London";

  services.syslogd.enable = true;

  # services.redshift = {
  #   enable = true;
  #   latitude = "51.0";
  #   longitude = "0.0";
  # };

  # Package overrides
  nixpkgs.config.packageOverrides = pkgs: {
    st = (pkgs.st.overrideAttrs (oldAttrs: {
      src = ./overrides/st;
    }));
  };

  # SystemD services
  # systemd.services.xkeywatch = {
  #   enable = true;
  #   serviceConfig.Type = "oneshot";
  #   environment = {
  #     HOME = "/home/yannick";
  #   };
  #   script = ''
  #     sxhkd &
  #   '';
  # };

  # services.plex = {
  #   enable = true;
  #   openFirewall = true;
  # };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video %S%p/brightness", RUN+="${pkgs.coreutils}/bin/chmod g+w %S%p/brightness"
  '';

  services.udev.path = [
    pkgs.coreutils # for chgrp
  ];
#  nixpkgs.config.packageOverrides = pkgs: {
#    dwm = pkgs.dwm.override {
#      name = "dwm-6.0";
#      patches =
#        [ ./packages/dwm/dwm-st.patch
#          ./packages/dwm/dwm-6.0-font-size.diff
#          ./packages/dwm/dwm-6.0-cmd-for-modifier.diff
#        ];
#    };
#  };
#
#    st = pkgs.callPackage ./st {
#      patches =
#        [ ./packages/st/st-solarized-light.diff
#          ./packages/st/st-0.5-no-bold-colors.diff
#        ];
#    };
#  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    # Utilities
    xdotool
    light # Brightness setting
    redshift # Color temperature
    fff # File manager
    sxiv # Image Viewer
    sxhkd # X Daemon for shortcuts
    maim # Screenshot tool
    libnotify
    git-crypt
    gnupg # File encryption
    docker
    ripgrep # Keyword search
    direnv # Automatic env setup

    # Dev
    python
    (python37.withPackages(ps: with ps; [ setuptools psutil ]))
    gitAndTools.gitFull
    manpages
    wget sudo
    tree
    gnumake
    gcc
    zlib
    (st.overrideAttrs (oldAttrs: { # Terminal with overrides
      src = ./overrides/st;
    }))
    vscode

    nix
    haskellPackages.ghcid
    haskellPackages.fast-tags
    # haskell.packages.ghc801.ghc
    # haskell.packages.ghc801.cabal-install
    haskell.packages.ghc864.ghc
    haskell.packages.ghc864.cabal-install
    cabal-install
    nix-prefetch-git


    # Media
    # plex

    # Useful
    skypeforlinux
    qbittorrent
    bc # Calculator
    pstree

    # I3
    dunst
    i3lock
    i3status
    compton
    dunst
    hsetroot #wallpapers
    xsel
    rofi
    noto-fonts
    mplus-outline-fonts
    xsettingsd
    lxappearance
    scrot
    viewnior

    dmenu
    xscreensaver
    xclip

    chromium
    git
    htop
    networkmanagerapplet

    nix-prefetch-scripts
    neovim
    wget
    which
  ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:
  programs.zsh.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin pkgs.gutenprint ];



  # Enable the KDE Desktop Environment.
  services.xserver = {
    libinput.enable = true;
    libinput.naturalScrolling = true;
    enable = true;
    layout = "gb";
    desktopManager = {
      default = "none";
      xterm.enable = false;
    };
    displayManager.auto.enable = true;
    displayManager.auto.user = "yannick";
    windowManager.default = "i3";
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yannick = {
    isNormalUser = true;
    createHome = true;
    group = "users";
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" ];
    home = "/home/yannick";
    uid = 1000;
  };

  nix.trustedUsers = [ "root" "yannick" ];

  # This value determines the NixOS release with which your system is to be
  # compatible in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
