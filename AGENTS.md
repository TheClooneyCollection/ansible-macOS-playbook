# Repository Guidelines

## Project Structure & Module Organization
- Root: `main.yml` (entry play), `ansible.cfg`, `inventory`, `requirements.yml`, `install.zsh`.
- Roles: `roles/shared_fonts` (Homebrew fonts helper role with its own README).
- Inventory: `inventory` targets local host (`127.0.0.1 ansible_connection=local`).
- Configure paths in `ansible.cfg` (`roles_path`, `inventory`, `become`, `stdout_callback: yaml`).

## Build, Test, and Development Commands
- Run via script: `zsh install.zsh` — sets PATH, installs Ansible, galaxy deps, then runs the play with sudo prompt.
- Install roles: `ansible-galaxy install -r requirements.yml` — installs `geerlingguy.mac` collection.
- Syntax check: `ansible-playbook -i inventory --syntax-check main.yml` — validates YAML/Ansible.
- Dry run: `ansible-playbook -i inventory -K --check --diff main.yml` — preview changes.
- Targeted run: `ansible-playbook -i inventory -K main.yml --tags homebrew` or `--limit 127.0.0.1`.

## Coding Style & Naming Conventions
- YAML: 2-space indent, block lists aligned, quote strings with interpolation ("{{ var }}").
- Tasks: clear, imperative names (e.g., "Install Homebrew Casks"). Prefer modules over `shell/command`.
- Variables: `snake_case` (e.g., `homebrew_user`); Tags: `kebab-case` (e.g., `homebrew-setup`).
- Idempotence: set `changed_when`/`creates` and avoid unnecessary `shell` usage.

## Testing Guidelines
- Local checks: `--syntax-check`, then `--check --diff` before real runs.
- Scope work: use `--tags`, `--skip-tags`, and `--start-at-task` for iteration.
- Safety: validate destructive changes behind explicit tags; prefer `when:` guards.
- No formal unit tests; keep tasks idempotent and reversible.

## Commit & Pull Request Guidelines
- Commits: follow the repo's current subject style when possible. Prefer scoped conventional subjects for feature work (e.g., `feat(devtools): add bat`, `feat(casks): add Ghostty to Homebrew casks`) and keep legacy unscoped subjects only when matching existing areas that still use them.
- PRs must include: purpose/summary, scope (files/roles/tags touched), example command used to verify (e.g., the exact `ansible-playbook` line), and notes on idempotence.
- Link related issues; include `--check`/`--diff` output snippets when behavior changes.

## Security & Configuration Tips
- Privilege: use `become: true` only where needed; run with `-K` (sudo prompt).
- Secrets: never commit secrets; keep sensitive prompts hidden (`no_log: true`).
- macOS setup: ensure Xcode CLT and Homebrew are installed (script handles this).
