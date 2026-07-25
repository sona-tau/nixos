_: {
  flake.modules.homeManager.taskwarrior =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      taskrcBase = pkgs.writeText "taskrc-base" ''
        data.location=~/.local/share/task

        			# --- urgency coefficients ---
        			urgency.due.coefficient=12.0
        			urgency.priority.coefficient=6.0
        			urgency.active.coefficient=4.0
        			urgency.project.coefficient=1.5
        			urgency.age.coefficient=2.0
        			urgency.tags.coefficient=1.0
        			urgency.annotations.coefficient=1.0
        			urgency.blocking.coefficient=8.0
        			urgency.blocked.coefficient=-5.0
        			urgency.waiting.coefficient=-3.0
        			urgency.scheduled.coefficient=-5.0
        			urgency.inherit=1

        			# --- tag-based urgency ---
        			urgency.user.tag.next.coefficient=4.0
        			urgency.user.tag.someday.coefficient=-8.0
        			urgency.user.tag.fun.coefficient=-2.0

        			# --- project-based urgency ---
        			urgency.user.project.health.coefficient=3.0

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

        			# --- UDAs ---
        			uda.estimate.type=numeric
        			uda.estimate.label=Est(min)
        			urgency.uda.estimate.coefficient=-0.005

        			uda.difficulty.type=string
        			uda.difficulty.label=Difficulty
        			uda.difficulty.values=trivial,easy,medium,hard
        			urgency.uda.difficulty.trivial.coefficient=-0.5
        			urgency.uda.difficulty.easy.coefficient=0.0
        			urgency.uda.difficulty.medium.coefficient=0.5
        			urgency.uda.difficulty.hard.coefficient=1.0

        			uda.energy.type=string
        			uda.energy.label=Energy
        			uda.energy.values=low,medium,high
        			urgency.uda.energy.low.coefficient=-0.5
        			urgency.uda.energy.medium.coefficient=0.0
        			urgency.uda.energy.high.coefficient=0.5

        			# --- display ---
        			color=on
        			confirmation=yes
        			dateformat=Y-M-D
        			report.next.columns=id,start.age,priority,project,tags,scheduled,due,until,estimate,uda.difficulty,uda.energy,description,urgency
        			report.next.labels=ID,Active,P,Project,Tags,Sched,Due,Until,Est,Diff,Nrg,Description,Urg

        			# --- colors ---
        			# foreground-only: no background colors to avoid clashing with terminal theme
        			color.tagged=
        			color.due=yellow
        			color.due.today=bold yellow
        			color.overdue=bold red
        			color.active=bold green
        			color.blocked=red
        			color.blocking=bold cyan
        			color.scheduled=gray8
        			color.completed=gray8
        			color.deleted=gray8'';

      wbsImport = pkgs.writeScriptBin "wbs-import" (builtins.readFile ../assets/wbs-import.nu);

      taskAdd = pkgs.writeShellApplication {
        name = "task-add";
        runtimeInputs = with pkgs; [
          gum
          taskwarrior3
        ];
        text = ''
          DESCRIPTION="$(gum input --header="Description:")"
          				PROJECT="$(gum input --header="Project:")"
          				PRIORITY="$(gum choose --header="Priority:" "H" "M" "L")"
          				DIFFICULTY="$(gum choose --header="Difficulty:" "triv" "easy" "medm" "hard")"
          				ENERGY="$(gum choose --header="Energy required:" "lo" "md" "hi")"	
          				ESTIMATE="$(gum choose --header="Estimate (minutes):" "15" "30" "60" "120" "180" "240" "360")"
          				SCHEDULED="$(gum input --header="Scheduled:")"
          				DUE="$(gum input --header="Due:")"
          				WAIT="$(gum input --header="Wait:")"
          				DEPENDS="$(gum input --header="Depends:")"

          				TAGS=""
          				if gum confirm "Does this have any tags?"; then
          					TAGS="$(gum input --header="Tags (space-separated):")"
          				fi

          				ID="$(task add "$DESCRIPTION" \
          					project:"$PROJECT" \
          					priority:"$PRIORITY" \
          					difficulty:"$DIFFICULTY" \
          					energy:"$ENERGY" \
          					estimate:"$ESTIMATE" \
          					scheduled:"$SCHEDULED" \
          					due:"$DUE" \
          					wait:"$WAIT" \
          					depends:"$DEPENDS" | grep -oE '[0-9]+')"

          				if [[ -n "$TAGS" ]]; then
          					for tag in $TAGS; do
          						task "$ID" modify +"$tag"
          					done
          				fi'';
      };

      contextSwitchScript = pkgs.writeShellScript "task-context-switch" ''
        hour=$(date +%-H)
        				if   [[ $hour -ge 6  && $hour -lt 12 ]]; then ctx=morning
        				elif [[ $hour -ge 12 && $hour -lt 17 ]]; then ctx=afternoon
        				elif [[ $hour -ge 17 && $hour -lt 21 ]]; then ctx=evening
        				else                                          ctx=night
        				fi
        				${pkgs.taskwarrior3}/bin/task context "$ctx"'';
    in
    {
      home.packages = with pkgs; [
        nushell
        taskwarrior3
        taskwarrior-tui
        taskAdd
        wbsImport
      ];

      # Write taskrc only on first install
      # taskwarrior needs to write context= at runtime.
      home.activation.taskrc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        target="${config.xdg.configHome}/task/taskrc"
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
