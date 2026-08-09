# Test fixtures

Fixtures in this directory are committed to the repository and used directly by `.circleci/test-deploy.yml`.

* `clean/main.py` has no Bandit findings. The command, install and executor tests assert that Bandit exits 0 when this file is scanned.
* `insecure/main.py` has three deliberate findings: `B324` (HIGH), `B104` (MEDIUM) and `B101` (LOW). `B324` being the only HIGH severity finding is what the `severity-level` / `skips` test relies on, so keep that property when editing the fixture.

Keep the fixtures in this directory synchronized with the expectations in `.circleci/test-deploy.yml`. Do not generate duplicate fixtures inside the CircleCI configuration.

