# Test fixtures

Fixtures in this directory are committed to the repository and used directly by `.circleci/test-deploy.yml`.

* `clean/main.py` has no Bandit findings. The command, install and executor tests assert that Bandit exits 0 when this file is scanned.
* `insecure/main.py` has three deliberate findings: `B324` (HIGH), `B104` (MEDIUM) and `B101` (LOW). `B324` being the only HIGH severity finding is what the `severity-level` / `skips`, `config-file` and `ini-path` tests rely on, so keep that property when editing the fixture.
* `config/bandit.yaml` skips `B324` and is used to verify that the `config-file` parameter loads and applies a Bandit configuration file.
* `config/.bandit` skips `B324` and is used to verify that the `ini-path` parameter loads and applies a Bandit INI configuration file.

Keep the fixtures in this directory synchronized with the expectations in `.circleci/test-deploy.yml`. Do not generate duplicate fixtures inside the CircleCI configuration.
