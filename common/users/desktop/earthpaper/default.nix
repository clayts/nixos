{
  pkgs,
  lib,
  ...
}: let
  earthpaper = pkgs.writeShellScript "earthpaper" ''
    usage() {
        echo "$0 downloads a random EarthView (https://g.co/ev) image."
        echo "Usage: $0 [-o output_file]"
        echo "Options:"
        echo "  -o FILE    Specify output image file (default: <image id>.jpeg)"
        echo "  --help/-h  Show this help message"
    }

    image=""
    while getopts "o:" opt; do
        case $opt in
            o) image="$OPTARG" ;;
            h) usage && exit 1 ;;
            ?) usage && exit 1 ;;
        esac
    done

    id=$(${pkgs.jq}/bin/jq -r '.[]' ${./image-ids.json} | shuf -n 1)

    if [ -z $id ];
    then
      exit 1
    fi

    if [ -z $image ];
    then
        image="$id.jpeg"
    fi

    dir=$(mktemp -d)

    ${pkgs.curl}/bin/curl -s "https://www.gstatic.com/prettyearth/assets/data/v3/$id.json" -o $dir/data.json

    read -r latitude longitude elevation country attribution < <(${pkgs.jq}/bin/jq -r '.lat, .lng, .elevation, .geocode.country, .attribution' $dir/data.json | tr '\n' ' ')
    url="https://maps.google.com/?q=$latitude,$longitude"

    ${pkgs.jq}/bin/jq -r '.dataUri' $dir/data.json | sed 's/^data:image\/jpeg;base64,//' | base64 -d > "$image"

    echo """ID:          $id
    Country:     $country
    Latitude:    $latitude
    Longitude:   $longitude
    Elevation:   $elevation
    Map URL:     $url
    Attribution: $attribution"""

    rm -Rf $dir
  '';
  earthpaper-switcher = pkgs.writeShellScriptBin "earthpaper-switcher" ''
    dir="$HOME/.earthpaper"
    image_tmp=$(mktemp) &&
    info_tmp=$(mktemp) &&
    chmod +r $image_tmp &&
    chmod +r $info_tmp &&
    (
        echo "Fetching wallpaper:" &&
        mkdir -p $dir &&
        ${earthpaper} -o $image_tmp > $info_tmp &&
        cat $info_tmp &&
        mv $image_tmp $dir/wallpaper.jpeg &&
        mv $info_tmp $dir/wallpaper-info.txt
    ) || (
        rm $temp && echo "Failed" && exit 1
    )
  '';
in {
  home.activation = {
    init_earthpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
      [ ! -d "$HOME/.earthpaper" ] && ${earthpaper-switcher}/bin/earthpaper-switcher
    '';
  };

  systemd.user.timers."earthpaper" = {
    Unit.Description = "Timer for earthpaper service";
    Timer = {
      Unit = "earthpaper";
      OnCalendar = "daily";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };

  systemd.user.services."earthpaper" = {
    Unit.Description = "Earthpaper switcher";

    Service = {
      Type = "oneshot";
      ExecStart = "${earthpaper-switcher}/bin/earthpaper-switcher";
    };
    Install.WantedBy = ["default.target"];
  };

  home.packages = [
    earthpaper-switcher
  ];
}
