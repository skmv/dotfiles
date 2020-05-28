{ config, pkgs, ... }:

{

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      # ( pkgs.lua.withPackages (ps: with ps; [ luarocks mpack ]) )
      # ( pkgs.python37.withPackages (ps: with ps; [ pip flake8 black pynvim python-language-server.override { pylint = null; } ]) )

      pkgs.git
      pkgs.zsh
    ];

  environment.shells = [ pkgs.zsh ];

  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "right";
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.trackpad.Clicking = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.trustedUsers = [ "root" "ramz" ];
  nix.gc.automatic = true;

  # nix.package = pkgs.nix;

  programs.zsh.enable = true;
  programs.zsh.enableBashCompletion = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 4;
  nix.buildCores = 1;

}
