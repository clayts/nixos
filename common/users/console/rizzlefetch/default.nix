{pkgs, ...}: let
  pythonEnv = pkgs.python313.withPackages (ps:
    with ps; [
      terminaltexteffects
    ]);
in {
  home.packages = [
    (pkgs.writeScriptBin "rizzlefetch" ''
      # export PATH=${pkgs.lib.makeBinPath [pkgs.toilet]}:$PATH

      # cleanup() {
      #     [ -n "$PYTHON_PID" ] && kill "$PYTHON_PID" 2>/dev/null
      #     stty sane
      #     printf '\033[?25h'
      # }
      # trap cleanup EXIT INT

      # # Launch Python in background, stdin detached (with -u for unbuffered output)
      # ${pythonEnv}/bin/python -u ${./script.py} < /dev/null &
      # PYTHON_PID=$!

      # stty raw -echo
      # printf '\033[?25l'  # Hide cursor immediately after raw mode (ensures consistent visuals)

      # # Poll for key
      # while kill -0 "$PYTHON_PID" 2>/dev/null; do
      #     if read -N1 -t 0 KEY 2>/dev/null; then
      #         kill "$PYTHON_PID"
      #         wait "$PYTHON_PID" 2>/dev/null
      #         stty sane  # Already here for keypress case
      #         echo -n "$KEY"  # Pass through
      #         printf '\033[?25h\033[2J\033[H'  # Show cursor + clear
      #         clear
      #         exit 0
      #     fi
      # done

      # wait "$PYTHON_PID" 2>/dev/null  # Wait for full process termination and I/O flush
      # stty sane  # Restore cooked mode immediately, so zsh renders output + advances line
      # printf '\n\n'
      #
      #
      #

      export PATH=${pkgs.lib.makeBinPath [pkgs.toilet]}:$PATH
      ${pythonEnv}/bin/python ${./script.py}


    '')
  ];
}
