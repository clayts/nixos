{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ./hostfetch
    ./lsd.nix
    ./micro.nix
    ./scripts
  ];

  home = {
    packages = with pkgs; [
      grc
      fzf
      lsd
      fd
      git
      gh
      aichat
    ];
    sessionVariables = {
      EDITOR = "micro";
      GOPATH = "$HOME/.local/share/go";
    };
  };

  programs.nix-index.enable = true;
  programs.nix-index.enableZshIntegration = false; # slow - just use comma
  programs.nix-index-database.comma.enable = true;

  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "grc";
        src = "${pkgs.grc}/etc";
        file = "grc.zsh";
      }
      {
        name = "p10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
        file = "powerlevel10k.zsh-theme";
      }
      {
        name = "p10k-theme";
        src = ./powerlevel10k;
        file = "config.zsh";
      }
    ];
    shellAliases = {
      edit = "$EDITOR";
      open = "xdg-open";
      l = "lsd --almost-all --long --git --group-dirs first --no-symlink --date relative";
      ls = lib.mkForce "lsd --group-dirs first";
      lt = lib.mkForce "lsd --tree --long --git --group-dirs first --no-symlink --date relative";
      cd = "z";
    };
    sessionVariables = {
      GREP_OPTIONS = "--color=auto";
    };
    dotDir = ".config/zsh";
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    initContent = ''
      [[ -n $DISPLAY ]] && [[ $SHLVL -eq 1 ]] && hostfetch

      # keybindings
      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey "$terminfo[kcud1]" history-substring-search-down

      bindkey  "^[[H"   beginning-of-line
      bindkey  "^[[F"   end-of-line
      bindkey  "^[[3~"  delete-char
    '';
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };
}
