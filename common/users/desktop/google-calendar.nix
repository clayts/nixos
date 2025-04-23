{pkgs, ...}: {
  home.packages = [
    (pkgs.makeDesktopItem {
      name = "com.google.Calendar";
      desktopName = "Google Calendar";
      noDisplay = true;
      mimeTypes = ["text/calendar"];
      exec = "xdg-open https://www.google.com/calendar";
    })
  ];
}
