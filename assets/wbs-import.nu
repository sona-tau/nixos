#!/usr/bin/env nu

def slugify []: string -> string {
    $in
    | str downcase
    | str replace --all --regex '[*_`]' ''
    | str replace --all --regex '\s+' '-'
    | str replace --all --regex '[^a-z0-9-]' ''
    | str replace --all --regex '-+' '-'
    | str trim --char '-'
}

def parse_wbs [filepath: string] {
    let content = (open --raw $filepath)

    let h1 = ($content | lines | where { |l| $l =~ '^# ' } | get 0? | default '')
    let base = (
        $h1
        | str replace --regex '^#\s+' ''
        | str replace --regex '(?i)\s*WBS\s*$' ''
        | str trim
        | slugify
    )

    let items = (
        $content | lines | each { |line|
            let m = ($line | parse --regex '^(?P<indent>[ \t]*)-\s+\[(?P<status>[ x])\]\s+(?P<text>.+)')
            if ($m | is-empty) {
                null
            } else {
                let row = ($m | first)
                let depth = if ($row.indent | str contains "\t") {
                    ($row.indent | split chars | where { |c| $c == "\t" } | length)
                } else {
                    (($row.indent | str length) / 2 | math floor)
                }
                {
                    depth: $depth,
                    text: (
                        $row.text
                        | str replace --all --regex '\s*#\w+' ''
                        | str replace --all '**' ''
                        | str trim
                    ),
                    done: ($row.status == 'x')
                }
            }
        } | compact
    )

    let count = ($items | length)
    if $count == 0 { return [] }

    mut result = []

    for i in 0..($count - 1) {
        let item = ($items | get $i)
        if $item.done { continue }

        let next_depth = if ($i + 1) < $count {
            ($items | get ($i + 1)).depth
        } else { -1 }
        if $next_depth > $item.depth { continue }

        mut ancestors = []
        mut target = ($item.depth - 1)
        mut j = ($i - 1)

        while $j >= 0 and $target >= 0 {
            let prev = ($items | get $j)
            if $prev.depth == $target {
                $ancestors = [($prev.text | slugify)] ++ $ancestors
                $target -= 1
            }
            $j -= 1
        }

        let project = if ($ancestors | is-empty) {
            $base
        } else {
            ([$base] ++ $ancestors | str join '.')
        }

        $result = ($result | append { desc: $item.text, project: $project })
    }

    $result
}

def task_exists [desc: string] {
    let n = (^task rc.verbose=nothing $"description.is:($desc)" count | str trim | into int)
    $n > 0
}

def main [
    --dry-run
    --difficulty: string = ""   # trivial, easy, medium, hard
    --energy: string = ""       # low, medium, high
    --estimate: string = ""     # minutes (numeric)
    --scheduled: string = ""    # e.g. 2026-08-01 or tomorrow
    --due: string = ""          # e.g. 2026-09-01 or eom
    --wait: string = ""         # e.g. 2026-07-15
    ...files: string
] {
    if ($files | is-empty) {
        print "Usage: wbs-import [--dry-run] [--difficulty <val>] [--energy <val>]"
        print "                   [--estimate <min>] [--scheduled <date>] [--due <date>]"
        print "                   [--wait <date>] <file.md> ..."
        exit 1
    }

    mut attrs = []
    if ($difficulty | is-not-empty) { $attrs = ($attrs | append $"difficulty:($difficulty)") }
    if ($energy | is-not-empty)     { $attrs = ($attrs | append $"energy:($energy)") }
    if ($estimate | is-not-empty)   { $attrs = ($attrs | append $"estimate:($estimate)") }
    if ($scheduled | is-not-empty)  { $attrs = ($attrs | append $"scheduled:($scheduled)") }
    if ($due | is-not-empty)        { $attrs = ($attrs | append $"due:($due)") }
    if ($wait | is-not-empty)       { $attrs = ($attrs | append $"wait:($wait)") }

    for filepath in $files {
        let tasks = (parse_wbs $filepath)
        print $"\n($filepath | path basename) -> ($tasks | length) pending leaf tasks"

        mut created = 0
        mut skipped = 0
        mut last_id = {}  # project prefix -> last task ID created in that branch

        for task in $tasks {
            if (task_exists $task.desc) {
                $skipped += 1
                continue
            }

            # Build all project prefixes from least to most specific: [a, a.b, a.b.c]
            let parts = ($task.project | split row '.')
            let prefixes = (1..($parts | length) | each { |i| $parts | first $i | str join '.' })

            # Find dep: most specific prefix that has a recorded ID
            let ids = $last_id
            let dep_id = (
                $prefixes
                | reverse
                | each { |p| if $p in $ids { $ids | get $p } else { null } }
                | compact
                | get 0?
            )

            let dep_attr = if (not ($dep_id | is-empty)) { [$"depends:($dep_id)"] } else { [] }
            let cmd_args = [$task.desc $"project:($task.project)" '+wbs'] ++ $attrs ++ $dep_attr

            if $dry_run {
                print $"  [dry] task add ($cmd_args | str join ' ')"
                let fake_id = ($created + 1 | into string)
                for prefix in $prefixes { $last_id = ($last_id | upsert $prefix $fake_id) }
            } else {
                let new_id = (
                    ^task rc.verbose=new-id add ...$cmd_args
                    | lines
                    | each { |l| $l | parse "Created task {id}." }
                    | flatten
                    | get 0?.id
                    | default ""
                )
                for prefix in $prefixes { $last_id = ($last_id | upsert $prefix $new_id) }
            }
            $created += 1
        }

        let action = if $dry_run { "would create" } else { "created" }
        print $"  ($created) ($action), ($skipped) skipped \(duplicates\)"
    }
}
