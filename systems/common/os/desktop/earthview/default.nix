{pkgs, ...}: {
  systemd.timers."wallpaper-switcher" = {
    enable = true;
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services."wallpaper-switcher" = {
    script = ''
      echo "Fetching index"
      baseURL="https://raw.githubusercontent.com/clayts/Wallpapers/master"
      indexPath="index.txt"
      index=($(${pkgs.curl}/bin/curl -s "$baseURL/$indexPath"))
      echo "Index contains ''${#index[@]} images"
      path="$(printf "%s\n" "''${index[@]}" | shuf -n1)"
      if [ "$path" = "" ]
      then
          echo "Failed"
          exit 1
      fi
      echo "Fetching $path"
      temp=$(mktemp) && chmod +r $temp &&
      (
          ${pkgs.curl}/bin/curl -s "$baseURL/$path" > $temp &&
          mv $temp /tmp/wallpaper.jpg && echo "Wrote /tmp/wallpaper.jpg"
      ) || (
          rm $temp && echo "Failed" && exit 1
      )
    '';
    enable = true;
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "earthview" ''
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

      id=$(jq -r '.[]' ${./image-ids.json} | shuf -n 1)

      if [ -z $image ];
      then
          image="$id.jpeg"
      fi

      dir=$(mktemp -d)

      curl -s "https://www.gstatic.com/prettyearth/assets/data/v3/$id.json" -o $dir/data.json

      read -r latitude longitude elevation country < <(jq -r '.lat, .lng, .elevation, .geocode.country' $dir/data.json | tr '\n' ' ')
      url="https://maps.google.com/?q=$latitude,$longitude"

      echo """ID:        $id
      Country:   $country
      Latitude:  $latitude
      Longitude: $longitude
      Elevation: $elevation
      Map URL:   $url"""

      jq -r '.dataUri' $dir/data.json | sed 's/^data:image\/jpeg;base64,//' | base64 -d > "$image"

      rm -Rf $dir
    '')
  ];
}
