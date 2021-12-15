# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  setMultiple = value: attrList:
    lib.genAttrs attrList ( x: value );
in
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''experimental-features = nix-command flakes'';
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Canada/Eastern";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true;
  };

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;
  services = {
    xserver = {
      enable = true;
      libinput.enable = true;
      windowManager.xmonad = setMultiple true [
        "enable"
        "enableContribAndExtras"
      ];
      xkbVariant = "colemak_dh";
      xkbOptions = "shift:both_capslock";
    };
  };
  
  fonts = {
    fontDir.enable = true;
    enableDefaultFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [
                              "Inconsolata"
                              "LiberationMono"
                              "Noto"
                              "Ubuntu"
                            ]; })
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Inconsolata" ];
        emoji = [ "Noto" ];
      };
    };
  };
    
  users.users.lord-valen = {
    isNormalUser = true;
    createHome = true;
    uid = 1000;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "password";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wget
    brave
    kitty
    discord
    xclip
    rofi
  ];
   
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
