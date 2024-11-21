{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    zed-editor

    # Nix
    alejandra
    # nil
    nixd

    # Git
    gitg
    git
    gh
  ];
}
