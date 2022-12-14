{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "thinkpad";
    networkmanager.enable = true;
    firewall.enable = false;
  };  

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  sound.enable = true; 
  hardware.pulseaudio.enable = true;

  services = {
    gvfs.enable = true;
    tlp.enable = true;

    picom = {
      enable = true;
      inactiveOpacity = 0.8;
      activeOpacity = 1;
      vSync = true;
      backend = "glx";
    };

    xserver = {
      enable = true;
      layout = "dk";
      xkbOptions = "caps:escape";
      libinput.enable = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };

    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = { EDITOR = "vim"; };
    systemPackages = with pkgs; [
      ((vim_configurable.override {  }).customize{
        name = "vim";
        vimrcConfig.customRC = ''
          set nocompatible
          set showmatch
          set ignorecase
          set hlsearch
          set incsearch
          set tabstop=2
          set softtabstop=2
          set expandtab
          set shiftwidth=2
          set autoindent
          set number relativenumber
          syntax on
          set ttyfast
        '';
        }
      )
      wget
      curl
      unzip
      git
      firefox
      darktable
      keepassxc
      libreoffice
      htop
      signal-desktop
      kitty
      pcmanfm
      rofi
      neofetch
      haskell-language-server
      cabal-install
      ghc
      haskellPackages.xmobar
      nitrogen
      lxappearance
      pavucontrol
    ];
  };

  system = {
    copySystemConfiguration = true;
    stateVersion = "22.11";
  };
}
