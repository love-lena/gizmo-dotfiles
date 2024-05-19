let
  pkgs = import <nixpkgs> {};
  nixRelease = hash: (import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz"));
  ryelang = import ./ryelang.nix { pkgs=pkgs; };
  commonPackages = [
    pkgs.bat
    pkgs.cmake
    pkgs.ctags
    pkgs.docker
    pkgs.docker-compose
    pkgs.eza
    pkgs.fd
    pkgs.fish
    pkgs.fzf
    pkgs.gitAndTools.delta
    pkgs.htop
    pkgs.kubectx
    pkgs.leiningen
    pkgs.neovim
    pkgs.ripgrep
    pkgs.tldr
    pkgs.tmux
    pkgs.vim
    pkgs.watch
    pkgs.yq
    pkgs.zsh
  ];

  # Linux-specific packages
  linuxPackages = [
    pkgs.gcc9
    pkgs.git
    pkgs.jq
    pkgs.wget
    ryelang
  ];
  # MacOS-specific packages
  darwinPackages = [
    pkgs.font-awesome
    pkgs.nerdfonts
    
  ];
  packagesToInstall = commonPackages
  ++ (if pkgs.stdenv.isLinux then linuxPackages else [])
  ++ (if pkgs.stdenv.isDarwin then darwinPackages else []);
in
  {
    commonPackages = commonPackages;
    linuxPackages = linuxPackages;
    darwinPackages = darwinPackages;
    packagesToInstall = packagesToInstall;
  }
