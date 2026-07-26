# bashy improvement plan, round three

Round one (`doc/plan_done.md`) was the installer path. Round two
(`doc/plan_done2.md`) was shell startup, which went from 2.95 s to 1.01 s.

This round is about the prompt, which runs far more often than startup, plus the
correctness bugs and coverage gaps that turned up while looking at it.

Ordered by what is worth doing first.

Status legend: `DONE`, `TODO`.

## 1. Every prompt costs 150 ms - DONE, partly

Startup is paid once per shell. The prompt is paid after **every command you run**,
so a cost here is felt far more often.

Measured over twenty prompts on this machine, twice, a few minutes apart:

| function | cost |
| --- | --- |
| `_bashy_powerline_shell_prompt` | **100 ms** |
| `prompt_node` | 8 ms |
| `prompt_k8s` | 8 ms |
| `prompt_gems` | 8 ms |
| `prompt_aws` | 8 ms |
| `prompt_auto` | 8 ms |
| `prompt_gcp` | 7 ms |
| `prompt_error` | 0 ms |
| total `bashy_prompt` | **154 ms** |

`_bashy_powerline_shell_prompt` runs `powerline-shell` on every prompt, and that
binary takes 80 to 100 ms by itself - it is a python program that starts a fresh
interpreter each time. This is inherent to powerline-shell, not a bug in the plugin.

Options, roughly in order of how much they would help:

- Use a compiled prompt instead. `starship` is already a plugin here and does the
  same job in single digit milliseconds. That is a preference change, not a fix, so
  it belongs to you rather than to me.
- Keep powerline-shell but only recompute when something relevant changed. The
  prompt depends on cwd, git state and exit code; a cheap guard on `PWD` plus the
  exit code would skip most invocations.
- The seven remaining plugins cost about 8 ms each and roughly 50 ms together. They are cheap
  individually but they all run unconditionally, including in directories where
  they have nothing to say. `prompt_gcp` and `prompt_aws` in particular shell out.

Even leaving powerline-shell alone, the other seven are worth a look.

The seven were the win, and the cause was shared. All of them call `git_is_inside`
first, and that forked `git rev-parse` every time, so the same question was being
asked seven times per prompt at about 4 ms each. `core/git.sh` now remembers the
answer per directory, which is what the TODO comment already sitting in that file
asked for. `git_is_inside_flush` clears it if a repository appears or disappears
under a directory already visited.

| | before | after |
| --- | --- | --- |
| `bashy_prompt` | 154 ms | **115 ms** |
| each of the seven plugins | ~8 ms | ~3.5 ms |
| `git_is_inside` | 4 ms | 0.5 ms |

powerline-shell itself is untouched and still costs about 100 ms of the remaining
115. Caching its output is **not** safe: the prompt renders live git branch and
dirty state, so a cache keyed on cwd and exit code would show stale information
after any commit or checkout. Replacing it with a compiled prompt remains your
call, not a fix I should make.

## 2. Two plugins bind both namerefs to the same argument - DONE

`plugins/prompt.sh` line 17 and `plugins/fail.sh` line 3 both do:

	local -n __var=$1
	local -n __error=$1

The second one should be `$2`. As written, `__var` and `__error` are the same
variable, so assigning the error message overwrites the status code and the caller
sees a string where it expects 0 or 1.

These are the only two activation functions in the tree that do not take `__error`
from `$2`, so they are typos rather than a convention.

Both fixed. `_activate_fail` now reports `var=1` with its message intact, where
before the message overwrote the status.

## 3. `core/completion.sh` and `core/profile.sh` have no tests - DONE

Both modules were added in round two and both are load bearing: the completion
cache decides whether a stale completion is served, and `is_profile` decides
whether the profiling path runs at all.

Round two caught a real bug in the completion stamp only because it was tested by
hand at the time. That test was never written down.

Worth covering:

- a cold call generates the cache, a warm one reuses it
- a changed tool binary invalidates it, including a change within the same second
- a failing command leaves no cache file behind
- a missing tool fails without poisoning anything
- `is_profile` and `is_step` default to off, and respond to their variables

`tests/completion.sh` and `tests/profile.sh` added, twelve tests, all of the above
covered. The invalidation test was checked by reintroducing the whole second stamp
bug from round two: it fails, so the test is real rather than decorative.

## 4. Startup is still one second - DONE, and it stays there

Round two took it from 2.95 s to 1.01 s and stopped there because the two big wins
were done. What is left is smaller and more diffuse, and worth re-profiling before
touching anything: put `readonly BASHY_PROFILE=0` in `~/.bashy.config`, open a
shell, and read `bashy_status_plugins`.

From the round two measurements the remaining shape was `complete` around 97 ms,
`uv` and `buck2` still costing real time despite the completion cache, and
`ai_agy`/`ai_claude` at about 42 ms each for a single `pass show`. That last one is
a gpg decryption and is not worth avoiding, since the alternative is caching a
secret to disk.

Re-profiled. `complete` at 111 ms, `uv` at 75 ms, `buck2` at 46 ms, then the two
`pass show` plugins at about 40 ms each.

`complete` was the interesting one: it had seven `source <(rs* complete bash)` calls
that round two missed. Routing them through `bashy_completion` made startup
**slower**, 0.97 s to 1.05 s, and measuring showed why. Those tools emit their
completion in 5 to 15 ms, while a cached call costs about 10 ms of its own for
`command -v`, a `stat` and sourcing a file. Below roughly 15 ms the cache is a net
loss. Reverted, and the threshold is now written down in `core/completion.sh` so the
next person does not repeat the experiment.

The round two conversions were checked against the same yardstick and are all
genuine wins: minikube 80 ms, kubectl 77 ms, gh 47 ms, uv 21 ms natively.

`uv`'s remaining cost is mostly `pass show`, not its completion, and that is a gpg
decryption worth paying rather than caching a secret to disk.

Startup stays at about 0.95 s. The half second in the plan was optimistic: what is
left is a long tail of plugins doing real work, not waste.

## 5. The prompt subsystem has no tests - DONE

`bashy_prompt`, `_bashy_prompt_register` and `_bashy_prompt_deregister` manage the
list of functions that run on every prompt, and a mistake there either breaks the
prompt or silently drops part of it. `_bashy_prompt_register` prepends rather than
appends, so registration order is reversed relative to `bashy.list`, which is
either deliberate or a bug and currently nothing documents which.

Item 2 is in this same file, so this is a natural pairing.

`tests/prompt.sh` added, six tests. The prepend turns out to be deliberate: the
`_bashy_array_push` version is sitting commented out right above it. The behaviour
is now pinned by a test and explained in the README instead of being folklore.

## 6. Nine prompt plugins, no documentation - DONE

`README.md` documents writing an activation function and writing an installer, but
nothing about writing a prompt plugin: that you register with
`_bashy_prompt_register`, that your function runs on every prompt so it must be
fast, and that it must not fork if it can help it.

Given item 1, the "must be fast" part is the whole point.

Added to `snipplets/main.md.mako`, so it survives `pydmt build`. Covers registering,
why speed matters, using `git_is_inside` rather than forking git, and the reverse
ordering.

## 7. Smaller items - DONE

- The commented out `pip` line in `bashy.list` now says why it is off and why the
  plugin stays.
- The version bump on every `pydmt build` is now noted in `CLAUDE.md`, since a
  built working copy shows diffs in `config/version.py` and `core/version.sh` that
  nobody made.
- `doc/TODO.txt` now opens with a note pointing at the three plans and listing the
  three of its items that are already done: the install hook, disabling plugins from
  `bashy.list`, and moving the internals to associative arrays. Each was checked
  against the code rather than assumed.
