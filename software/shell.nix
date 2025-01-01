{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    fzf
    lsd
    fd
    zoxide
    lnav
    stow
    pciutils
    lshw
    git
    gh
  ];
}
