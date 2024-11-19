{
  pkgs,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "rounded-window-corners";
  version = "ee43bdd8e9d9b10448dbd8bf80e29606d5490d88";

  src = fetchFromGitHub {
    owner = "flexagoon";
    repo = pname;
    rev = version;
    sha256 = "sha256-ih/PObZGun3gplkdRm7BRWnvvGpMkAHdnzyc1/vROTA=";
  };

  nativeBuildInputs = with pkgs; [
    glib.dev
    just
  ];

  npmDepsHash = "sha256-Xce5b/X3R1IE1b7RY9l7HgZ1TVAqq2b3hLETo14xks8=";
  dontNpmBuild = true;
  installPhase = ''
    just build
    mkdir -p $out/share/gnome-shell/extensions
    cp -R ./_build/ $out/share/gnome-shell/extensions/rounded-window-corners@fxgn
  '';

  npmPackFlags = ["--ignore-scripts"];

  NODE_OPTIONS = "--openssl-legacy-provider";

  meta = {
    description = "Rounded window corners GNOME extension";
  };
}
// {extensionUuid = "rounded-window-corners@fxgn";}
