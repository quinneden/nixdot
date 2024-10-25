{
  pkgs,
  outputs,
  overlays,
  secrets,
  lib,
  inputs,
  ...
}:
let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  my-python-packages =
    ps: with ps; [
      material-color-utilities
      numpy
      i3ipc
    ];
in
{
  boot.loader = {
    systemd-boot.enable = true;
    # grub.enable = true;
    # grub.efiSupport = true;
    # grub.device = "nodev";
    # grub.darkmatter-theme = {
    #   enable = true;
    #   style = "nixos";
    # };
  };
  hardware.graphics.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";

  hardware.asahi = {
    withRust = true;
    setupAsahiSound = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    # peripheralFirmwareDirectory = builtins.fetchTarball {
    #   url = "https://qeden.me/asahi-firmware.tar.gz";
    #   sha256 = "sha256-tsRkDsXr7NYsNLJoWHBd6xaybtT+SVw+9HYn4zQmezo=";
    # };
    peripheralFirmwareDirectory = /boot/asahi;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  programs.ssh.startAgent = true;

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
  # networking = {
  #   networkmanager.enable = true;
  #   firewall.enable = false;
  #};

  networking = {
    hostName = "nixos-macmini";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
    firewall.enable = false;
    hostId = "a25f4bea";
  };

  security.sudo.enable = true;
  services.blueman.enable = true;
  location.provider = "geoclue2";

  # services.redshift = {
  #   enable = true;
  #   brightness = {
  #     day = "1";
  #     night = "1";
  #   };
  #   temperature = {
  #     day = 5500;
  #     night = 3700;
  #   };
  # };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  # time = {
  #   hardwareClockInLocalTime = true;
  #   timeZone = "Asia/Kolkata";
  # };

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  users = {
    users.quinn = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "libvirtd"
        "adbusers"
      ];
      packages = with pkgs; [ ];
    };
    defaultUserShell = pkgs.zsh;
  };

  programs.adb.enable = true;
  # services.udev.packages = [
  #   pkgs.android-udev-rules
  # ];

  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";

  hardware.bluetooth = {
    enable = true;
    # settings.General = {
    #   Enable = "Source,Sink,Media,Socket";
    #   Experimental = true;
    # };
    powerOnBoot = true;
  };

  # systemd.services.bluetooth.serviceConfig.ExecStart = [
  #   ""
  #   "${pkgs.bluez}/libexec/bluetooth/bluetoothd -f /etc/bluetooth/main.conf"
  # ];

  security.rtkit.enable = true;
  virtualisation = {
    libvirtd.enable = true;
  };
  services.dbus.enable = true;
  # programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
		nixfmt-rfc-style
    nodejs
    lutgen
    home-manager
    lua-language-server
    bluez
    direnv
    unzip
    bluez-tools
    inotify-tools
    udiskie
    xorg.xwininfo
    brightnessctl
    networkmanager_dmenu
    (pkgs.python311.withPackages my-python-packages)
    libnotify
    xdg-utils
    gtk3
    niv
    st
    appimage-run
    jq
    # spotdl
    # osu-lazer
    # imgclr
    grim
    slop
    eww-wayland
    swaylock-effects
    git
    pstree
    mpv
    xdotool
    # spotify
    simplescreenrecorder
    brightnessctl
    pamixer
    dmenu
    nix-prefetch-git
    python3
		pure-prompt
    brillo
    wmctrl
    slop
    ripgrep
    imv
    element-desktop
    maim
    xclip
    wirelesstools
    xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86inputlibinput
    xorg.xorgserver
    xorg.xf86videoati
    asahi-bless
    asahi-btsync
    alejandra
    apfsprogs
    hfsprogs
    btrfs-progs
    micro
    wget
    zoxide
    bat
    gh
    nh
    git-crypt
  ];

  security.pam.services.gdm.enableGnomeKeyring = true;
  security.sudo.wheelNeedsPassword = false;

  fonts.packages = with pkgs; [
    material-design-icons
    dosis
    material-symbols
    rubik
    noto-fonts-color-emoji
    google-fonts
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Product Sans" ];
      monospace = [ "Iosevka Nerd Font" ];
    };
  };
  fonts.enableDefaultPackages = true;

  environment.shells = with pkgs; [ zsh ];
  programs.dconf.enable = true;

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  # services.printing.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "us,";
  };

  security.polkit.enable = true;

  nix = {
    settings = {
      access-tokens = [ "github=${secrets.github.api}" ];
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      extra-platforms = "x86_64-linux";
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      extra-substituters = [
        "${secrets.cachix.nixos-asahi.url}"
        "${secrets.cachix.quinneden.url}"
        "https://cache.lix.systems"
        "https://hyprland.cachix.org"
      ];
      extra-trusted-public-keys = [
        "${secrets.cachix.nixos-asahi.public-key}"
        "${secrets.cachix.quinneden.public-key}"
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      auto-optimise-store = true;
      warn-dirty = false;
      # substituters = [ "https://nix-gaming.cachix.org" ];
      # trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
    optimise.automatic = true;
  };

  system = {
    copySystemConfiguration = false;
    stateVersion = "24.11";
  };
}
