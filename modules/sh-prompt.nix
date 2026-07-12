{ ... }: {
  flake.modules.homeManager.sh-prompt = { ... }: {
    home.file.".local/bin/sh_prompt" = {
      executable = true;

      text = ''
        #!/usr/bin/env bash
        # dependencies: gum
        set -e


        dec="$(printf "%d\n" "$(head -c 1 /dev/random | od -A n -t u1)")"
        hex="$(printf "%x\n" "$dec")"

        val="$(gum input --header="What is 0x$hex in decimal?")"
        while [ "$val" -ne "$dec" ]
        do
        	gum log -l "error" "Try again."
        	val="$(gum input --header="What is 0x$hex in decimal?")"
        done
        			'';
    };
  };
}
