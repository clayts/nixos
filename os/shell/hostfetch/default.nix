{pkgs, ...}:
pkgs.writeShellApplication {
  name = "hostfetch";
  runtimeInputs = with pkgs; [lolcat ncurses figlet];
  text = ''
    logo=$(figlet -f ${./future.tlf} "$(hostname)")

    # shellcheck source=/dev/null
    source /etc/os-release

    loltext=$(echo "$logo" | lolcat -f -F 0.5)

    hardware=$(cat /sys/devices/virtual/dmi/id/product_name)
    os="$PRETTY_NAME"
    kernel=$(uname -sr)

    style_bold=$(tput bold)
    style_normal=$(tput sgr0)

    echo
    echo -n "  "
    echo -n "$loltext" | head -n1 | tr -d '\n'
    echo "''${style_bold}   Hardware: ''${style_normal}$hardware"
    echo -n "  "
    echo -n "$loltext" | head -n2 | tail -n1 | tr -d '\n'
    echo "''${style_bold}   OS: ''${style_normal}$os"
    echo -n "  "
    echo -n "$loltext" | tail -n1 | tr -d '\n'
    echo "''${style_bold}   Kernel: ''${style_normal}$kernel"
    echo
  '';
}
