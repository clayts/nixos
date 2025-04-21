{...}: {
  home.stateVersion = "25.05";

  imports = [
    ../common/firefox.nix
    ../common/ghostty.nix
    ../common/lsd.nix
    ../common/micro.nix
    ../common/other.nix
    ../common/zed-editor.nix
  ];
}
