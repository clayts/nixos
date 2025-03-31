{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    fzf
    lsd
    fd
    zoxide
    lnav
    pciutils
    lshw
    git
    gh
    bat
    alejandra
    nixd
  ];
}
