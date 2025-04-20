{pkgs, ...}: {
  # Fix sudo shlvl
  security.sudo.extraConfig = ''
    Defaults:root,%wheel env_keep+=SHLVL
  '';

  security.sudo.wheelNeedsPassword = false;

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
    l = "lsd --almost-all --long --git --group-dirs first --no-symlink --date relative";
    ls = "lsd --group-dirs first";
    lt = "lsd --tree --long --git --group-dirs first --no-symlink --date relative";
    cd = "z";
  };
  environment.sessionVariables = {
    EDITOR = "${pkgs.micro}/bin/micro";
    GOPATH = "$HOME/.local/share/go";
  };
  programs.direnv = {
    enable = true;
    loadInNixShell = false;
    nix-direnv.enable = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    vteIntegration = true;
    autosuggestions.enable = true;
    histFile = "$HOME/.config/zsh/history";
    interactiveShellInit = ''
      # zoxide
      # echo "INIT zoxide"
      eval "$(zoxide init zsh)"

      # fzf-tab
      # echo "INIT fzf-tab"
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} # set list-colors to enable filename colorizing

      # substring search
      # echo "INIT substring search"
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      bindkey "''${terminfo[kcuu1]}" history-substring-search-up
      bindkey "''${terminfo[kcud1]}" history-substring-search-down

      # syntax highlighting
      # echo "INIT syntax highlighting"
      source ${pkgs.zsh-f-sy-h}/share/zsh/site-functions/F-Sy-H.plugin.zsh

      # direnv
      # echo "INIT direnv"
      eval "$(direnv hook zsh)"

      # skip in tty
      if [[ -n $DISPLAY ]];
      then

        # hostfetch
        # echo "INIT hostfetch"
        [[ $SHLVL -eq 1 ]] && hostfetch

        # keybindings
        # echo "INIT keybindings"
        shift keybindings
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

        # Function to set window title
        # echo "INIT set_win_title()"
        function set_win_title() {
            print -Pn "\e]0;$1\a"
        }

        # Preexec hook to set title before executing command
        # echo "INIT preexec()"
        function preexec() {
            set_win_title "$1"
        }

        # Precmd hook to reset title after command completes
        # echo "INIT precmd()"
        function precmd() {
            set_win_title "zsh"
        }

        # powerlevel10k
        # echo "INIT powerlevel10k"
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

        # powerlevel10k theme
        # echo "INIT powerlevel10k theme"
        source ${./powerlevel10k.zsh}
      fi
    '';
  };
}
