# bashy improvement plan, round three

Round one (`doc/plan_done.md`) was the installer path. Round two
(`doc/plan_done2.md`) was shell startup, which went from 2.95 s to 1.01 s.

This round is about the prompt, which runs far more often than startup, plus the
correctness bugs and coverage gaps that turned up while looking at it.

Ordered by what is worth doing first.

Status legend: `DONE`, `TODO`.

## 1. Every prompt costs 150 ms - TODO

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

## 2. Two plugins bind both namerefs to the same argument - TODO

`plugins/prompt.sh` line 17 and `plugins/fail.sh` line 3 both do:

	local -n __var=$1
	local -n __error=$1

The second one should be `$2`. As written, `__var` and `__error` are the same
variable, so assigning the error message overwrites the status code and the caller
sees a string where it expects 0 or 1.

These are the only two activation functions in the tree that do not take `__error`
from `$2`, so they are typos rather than a convention.

## 3. `core/completion.sh` and `core/profile.sh` have no tests - TODO

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

## 4. Startup is still one second - TODO

Round two took it from 2.95 s to 1.01 s and stopped there because the two big wins
were done. What is left is smaller and more diffuse, and worth re-profiling before
touching anything: put `readonly BASHY_PROFILE=0` in `~/.bashy.config`, open a
shell, and read `bashy_status_plugins`.

From the round two measurements the remaining shape was `complete` around 97 ms,
`uv` and `buck2` still costing real time despite the completion cache, and
`ai_agy`/`ai_claude` at about 42 ms each for a single `pass show`. That last one is
a gpg decryption and is not worth avoiding, since the alternative is caching a
secret to disk.

The floor for 70 plugins is not zero, but half a second looks reachable.

## 5. The prompt subsystem has no tests - TODO

`bashy_prompt`, `_bashy_prompt_register` and `_bashy_prompt_deregister` manage the
list of functions that run on every prompt, and a mistake there either breaks the
prompt or silently drops part of it. `_bashy_prompt_register` prepends rather than
appends, so registration order is reversed relative to `bashy.list`, which is
either deliberate or a bug and currently nothing documents which.

Item 2 is in this same file, so this is a natural pairing.

## 6. Nine prompt plugins, no documentation - TODO

`README.md` documents writing an activation function and writing an installer, but
nothing about writing a prompt plugin: that you register with
`_bashy_prompt_register`, that your function runs on every prompt so it must be
fast, and that it must not fork if it can help it.

Given item 1, the "must be fast" part is the whole point.

## 7. Smaller items - TODO

- `plugins/pip.sh` is disabled in `bashy.list` and its completion is superseded by
  `uv`. It stays, per the never delete plugins rule, but the commented out line
  could say why rather than just being commented.
- `core/version.sh` is generated from `config/version.py` and the version bumps on
  every `pydmt build`, so a working copy that has been built shows a dirty
  `config/version.py` and `core/version.sh` that are not really changes. Worth
  knowing before assuming a diff means something.
- `doc/TODO.txt` predates all three of these plans and has not been reconciled with
  them. Some of it may already be done.
