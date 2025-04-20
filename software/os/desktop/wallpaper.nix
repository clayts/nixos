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
}
