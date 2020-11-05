{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ramz";
  home.homeDirectory = "/Users/ramz";

  home.packages = [
    pkgs.ag
    pkgs.ansible
    pkgs.argocd
    pkgs.aria2
    pkgs.asciinema
    pkgs.automake
    pkgs.awscli2
    pkgs.aws-vault
    pkgs.azure-cli
    pkgs.bash
    pkgs.bat
    pkgs.certbot
    pkgs.cfssl
    pkgs.clang
    pkgs.cmake
    pkgs.cntlm
    pkgs.coreutils-full
    pkgs.dep
    pkgs.direnv
    pkgs.dive
    pkgs.docker-machine-xhyve
    pkgs.docker-slim
    pkgs.dotnet-sdk_3
    pkgs.eksctl
    pkgs.exa
    pkgs.fd
    pkgs.ffmpeg
    pkgs.fzf
    pkgs.gawk
    pkgs.gettext
    pkgs.gitAndTools.gh
    pkgs.git-crypt
    pkgs.git-lfs
    pkgs.git-review
    pkgs.gnupg
    pkgs.gnutar
    pkgs.gnutls
    pkgs.go
    pkgs.gradle
    pkgs.graphviz
    pkgs.hadolint
    pkgs.httpie
    pkgs.imagemagick
    pkgs.ispell
    pkgs.jdk11
    pkgs.jq
    pkgs.jsonnet
    pkgs.kind
    pkgs.kotlin
    pkgs.kubectl
    pkgs.kubectx
    pkgs.kubie
    pkgs.kustomize
    pkgs.k9s
    pkgs.libxml2
    pkgs.libyaml
    pkgs.maven
    pkgs.minikube
    pkgs.mutagen
    pkgs.ncdu
    pkgs.nmap
    pkgs.notary
    pkgs.noti
    pkgs.openconnect
    pkgs.openvpn
    pkgs.packer
    pkgs.peco
    pkgs.rclone
    pkgs.reattach-to-user-namespace
    pkgs.rustup
    pkgs.step-cli
    pkgs.terraform
    pkgs.texinfo
    pkgs.tldr
    pkgs.tree
    pkgs.urlview
    pkgs.vault
    pkgs.watchexec
    pkgs.wget
    pkgs.xhyve
    pkgs.xsv
    pkgs.yarn
    pkgs.youtube-dl
    pkgs.yubico-pam
    pkgs.yubico-piv-tool
    pkgs.yubikey-manager
    pkgs.yubikey-personalization
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
}
