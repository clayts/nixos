{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "hostfetch" ''
      logo=$(${pkgs.figlet}/bin/figlet -f ${./future.tlf} "$(hostname)")

      loltext=$(echo "$logo" | ${pkgs.dotacat}/bin/dotacat -F 0.5)

      source /etc/os-release

      hardware="$(cat /sys/devices/virtual/dmi/id/product_version)"
      os="$PRETTY_NAME"
      kernel="$(uname -sr)"

      style_bold=$(${pkgs.ncurses}/bin/tput bold)
      style_normal=$(${pkgs.ncurses}/bin/tput sgr0)

      echo -n "$loltext" | head -n1 | tail -n1 | tr -d '\n'
      echo "''${style_bold}   Hardware: ''${style_normal}$hardware"
      echo -n "$loltext" | head -n2 | tail -n1 | tr -d '\n'
      echo "''${style_bold}   OS: ''${style_normal}$os"
      echo -n "$loltext" | head -n3 | tail -n1 | tr -d '\n'
      echo "''${style_bold}   Kernel: ''${style_normal}$kernel"
    '')
  ];
}
