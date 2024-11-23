{pkgs, ...}: let
  hostfetch = pkgs.callPackage ./hostfetch {};
in {
  # Fix sudo shlvl
  security.sudo.extraConfig = ''
    Defaults:root,%wheel env_keep+=SHLVL
  '';

  environment.systemPackages = with pkgs; [
    fzf
    lsd
    fd
    zoxide
  ];
  users.defaultUserShell = pkgs.zsh;
  system.userActivationScripts = {
    touchZshrc = {
      text = ''
        touch $HOME/.zshrc
        mkdir -p $HOME/.config/zsh/
      '';
    };
  };
  environment.shellAliases = {
    edit = "$EDITOR";
    open = "xdg-open";
    nixos-switch = "nh os switch $(readlink /etc/static/nixos)";
    l = "lsd --almost-all --long --git --group-dirs first --no-symlink --date relative";
    ls = "lsd --group-dirs first";
    lt = "lsd --tree --long --git --group-dirs first --no-symlink --date relative";
    cd = "z";
    pkg-tree = "function _pkg-tree() { lt $(nix build $* --print-out-paths --no-link); }; _pkg-tree";
    sys-git = "git --work-tree=/ --git-dir=/git";
  };
  environment.sessionVariables = {
    EDITOR = "${pkgs.micro}/bin/micro";
    GOPATH = "$HOME/.local/share/go";
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    vteIntegration = true;
    autosuggestions.enable = true;
    histFile = "$HOME/.config/zsh/history";
    interactiveShellInit = ''
      # zoxide
      eval "$(zoxide init zsh)"

      # fzf-tab
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} # set list-colors to enable filename colorizing

      # substring search
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      bindkey "''${terminfo[kcuu1]}" history-substring-search-up
      bindkey "''${terminfo[kcud1]}" history-substring-search-down

      # syntax highlighting
      source ${pkgs.zsh-f-sy-h}/share/zsh/site-functions/F-Sy-H.plugin.zsh

      # skip in tty
      if [[ -n $DISPLAY ]];
      then
        # shift keybindings
        shift-arrow() {
          ((REGION_ACTIVE)) || zle set-mark-command
          zle $1
        }
        shift-left()  shift-arrow backward-char
        shift-right() shift-arrow forward-char
        zle -N shift-left
        zle -N shift-right

        bindkey $terminfo[kLFT] shift-left
        bindkey $terminfo[kRIT] shift-right

        # hostfetch
        [[ $SHLVL -eq 1 ]] && ${hostfetch}/bin/hostfetch


        # Function to set window title
        function set_win_title() {
            print -Pn "\e]0;$1\a"
        }

        # Preexec hook to set title before executing command
        function preexec() {
            set_win_title "$1"
        }

        # Precmd hook to reset title after command completes
        function precmd() {
            set_win_title "zsh"
        }

        # powerlevel10k
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${./powerlevel10k/powerlevel10k.zsh}
      fi

    '';
  };
}
