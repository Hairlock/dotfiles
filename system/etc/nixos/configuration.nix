# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

# let
#   all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
# in
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


  networking.hostName = "nixos"; # Define your hostname.
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



  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain;
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Package overrides
  nixpkgs.config.packageOverrides = pkgs: {
    st = (pkgs.st.overrideAttrs (oldAttrs: {
      src = ./overrides/st;
    }));
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

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
    # Dev
    python
    python36
    gitAndTools.gitFull
    manpages
    wget sudo
    tree
    gnumake
    gcc
    zlib
    (st.overrideAttrs (oldAttrs: {
      src = ./overrides/st;
    }))
    # (all-hies.selection { selector = p: { inherit (p) ghc864 ghc863 ghc843; }; })

    nix
    haskellPackages.ghcid
    haskellPackages.fast-tags
    haskell.packages.ghc864.ghc
    haskell.packages.ghc864.cabal-install

    # Utilities
    light # Brightness setting
    vifm # File manager
    maim # Screenshot tool
    libnotify

    # Media
    plex

    # Useful
    skypeforlinux
    qbittorrent

    # I3
    dunst
    i3lock
    i3status
    compton
    dunst
    hsetroot #wallpapers
    # rxvt_unicode   #terminal
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
  services.printing.drivers = [ pkgs.hplipWithPlugin ];



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
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ]; # Enable ‘sudo’ for the user.
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
