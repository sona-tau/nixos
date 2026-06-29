{ ... }: {
	flake.modules.homeManager.keyring = { pkgs, ... }: {
		# Run gnome-keyring-daemon as a user service so it's guaranteed to be
		# on the correct D-Bus session regardless of how the session was started.
		# The system-level services.gnome.gnome-keyring + PAM don't reliably
		# reach the session bus in a getty-autologin + manual niri launch.
		home.packages = [ pkgs.gnome-keyring ];

		systemd.user.services.gnome-keyring = {
			Unit = {
				Description = "GNOME Keyring daemon (secret service)";
				After = [ "dbus.socket" ];
				Requires = [ "dbus.socket" ];
			};
			Service = {
				# No --start: we ARE the daemon, not connecting to a PAM-started one
				ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --foreground --components=secrets";
				Restart = "on-abort";
			};
			Install.WantedBy = [ "default.target" ];
		};
	};
}
