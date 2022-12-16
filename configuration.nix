{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "thinkpad";
    networkmanager.enable = true;
    firewall.enable = true;
  };  

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";

  location = {
    latitude = 56.15;
    longitude = 10.1;
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  sound.enable = true; 
  hardware.pulseaudio.enable = true;

  services = {
    xserver = {
      enable = true;
      layout = "dk";
      xkbOptions = "caps:escape";
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
      };
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
      };
    };

    gnome.core-utilities.enable = false;

    logind.extraConfig = ''
      HandlePowerKey=suspend
    '';
  };

  fonts = {
    fonts = with pkgs; [
      jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrains Mono" ];
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = { EDITOR = "vim"; };
    systemPackages = with pkgs; [
      ((vim_configurable.override {  }).customize{
        name = "vim";
        vimrcConfig.customRC = ''
          set nocompatible
          set backspace=indent,eol,start
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
          let &t_ut=""
          set termguicolors
          set background=dark
          colorscheme onedark
        '';
        }
      )

      curl
      git

      firefox
      darktable
      keepassxc
      libreoffice
      signal-desktop
      vscode
      virt-manager

      gnome.gnome-terminal
      gnome.nautilus
      gnome.file-roller
      gnome.eog
      gnome.gnome-tweaks
      gnome.gnome-bluetooth
      gnome.gnome-screenshot
      gnome.gnome-calculator
    ];
  };

  programs = {
    dconf.enable = true;
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };

    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
    };
  };

  users.users.joshua = {
    description = "Joshua Seiger-Eatwell";
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "camera"
      "video"
      "audio"
      "input"
      "libvirtd"
      ];
    group = "users";
    home = "/home/joshua";
  };

  security.sudo.wheelNeedsPassword = false;

  system = {
    copySystemConfiguration = true;
    stateVersion = "22.11";
  };
}
