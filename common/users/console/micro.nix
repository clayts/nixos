{...}: {
  xdg.desktopEntries."micro" = {
    name = "Micro";
    noDisplay = true;
  };
  programs.micro = {
    enable = true;
    settings = {
      "colorscheme" = "custom";
      "mkparents" = true;
      "wordwrap" = true;
      "softwrap" = true;
    };
  };
  home.file.".config/micro/colorschemes/custom.micro".text = ''
    color-link default "#F8F8F2"
    color-link comment "#75715E"
    color-link identifier "#66D9EF"
    color-link constant "#AE81FF"
    color-link constant.string "#E6DB74"
    color-link constant.string.char "#BDE6AD"
    color-link statement "#F92672"
    color-link symbol.operator "#F92672"
    color-link preproc "#CB4B16"
    color-link type "#66D9EF"
    color-link special "#A6E22E"
    color-link underlined "#D33682"
    color-link error "bold #CB4B16"
    color-link todo "bold #D33682"
    color-link hlsearch "#282828,#E6DB74"
    color-link statusline "#282828,#F8F8F2"
    color-link tabbar "#282828,#F8F8F2"
    color-link indent-char "#505050"
    color-link line-number "#AAAAAA,#323232"
    color-link current-line-number "#AAAAAA"
    color-link diff-added "#00AF00"
    color-link diff-modified "#FFAF00"
    color-link diff-deleted "#D70000"
    color-link gutter-error "#CB4B16"
    color-link gutter-warning "#E6DB74"
    color-link cursor-line "#323232"
    color-link color-column "#323232"
    #No extended types; Plain brackets.
    color-link type.extended "default"
    #color-link symbol.brackets "default"
    color-link symbol.tag "#AE81FF"
    color-link match-brace "#282828,#AE81FF"
    color-link tab-error "#D75F5F"
    color-link trailingws "#D75F5F"
  '';
  home.file.".config/micro/bindings.json".text = ''
    {
        "Alt-/": "lua:comment.comment",
    }
  '';
}
