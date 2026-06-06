{ ... }: {
	flake.modules.homeManager.taskwarrior = { config, lib, pkgs, ... }: let
		taskrcBase = pkgs.writeText "taskrc-base" ''
			data.location=~/.local/share/task

			# --- urgency coefficients ---
			# slight project to reward organized tasks
			urgency.due.coefficient=12.0
			urgency.priority.coefficient=6.0
			urgency.project.coefficient=1.5
			urgency.age.coefficient=2.0
			urgency.tags.coefficient=1.0
			urgency.annotations.coefficient=1.0
			urgency.blocking.coefficient=8.0
			urgency.blocked.coefficient=-5.0
			urgency.waiting.coefficient=-3.0
			urgency.scheduled.coefficient=-5.0

			# --- time-of-day contexts ---
			# tasks tagged:
			# - +morning
			# - +afternoon
			# - +evening
			# - +night only
			# surface in their own window
			# untagged tasks always appear
			context.morning.read=(+morning or (-morning -afternoon -evening -night))
			context.afternoon.read=(+afternoon or (-morning -afternoon -evening -night))
			context.evening.read=(+evening or (-morning -afternoon -evening -night))
			context.night.read=(+night or (-morning -afternoon -evening -night))

			# --- display ---
			color=on
			confirmation=yes
			dateformat=Y-M-D
			report.next.columns=id,start.age,priority,project,tags,scheduled,due,until,description,urgency
			report.next.labels=ID,Active,P,Project,Tags,Sched,Due,Until,Description,Urg
		'';

		contextSwitchScript = pkgs.writeShellScript "task-context-switch"
			''hour=$(date +%-H)
				if   [[ $hour -ge 6  && $hour -lt 12 ]]; then ctx=morning
				elif [[ $hour -ge 12 && $hour -lt 17 ]]; then ctx=afternoon
				elif [[ $hour -ge 17 && $hour -lt 21 ]]; then ctx=evening
				else                                          ctx=night
				fi
				${pkgs.taskwarrior3}/bin/task context "$ctx"'';
	in {
		home.packages = with pkgs; [
			taskwarrior3
			taskwarrior-tui
		];

		# Write taskrc only on first install
		# taskwarrior needs to write context= at runtime.
		home.activation.taskrc = lib.hm.dag.entryAfter [ "writeBoundary" ]
			''target="${config.xdg.configHome}/task/taskrc"
				mkdir -p "${config.xdg.configHome}/task"
				if [[ ! -f "$target" ]]; then
					cp ${taskrcBase} "$target"
					chmod 644 "$target"
				fi'';

		systemd.user.services.task-context-switch = {
			Unit.Description = "Set taskwarrior context for current time of day";
			Service = {
				Type = "oneshot";
				ExecStart = "${contextSwitchScript}";
			};
		};

		systemd.user.timers.task-context-switch = {
			Unit.Description = "Switch taskwarrior context at time boundaries";
			Timer = {
				OnCalendar = [
					"*-*-* 06:00:00"
					"*-*-* 12:00:00"
					"*-*-* 17:00:00"
					"*-*-* 21:00:00"
				];
				OnBootSec = "1min";
				Persistent = true;
			};
			Install.WantedBy = [ "timers.target" ];
		};
	};
}
