# Test fixtures

Fixtures used by `.circleci/test-deploy.yml`.

- `clean/` has no bandit findings. The command tests assert that bandit exits 0
  when this directory is scanned with the default parameters.
- `insecure/` has three deliberate findings: `B324` (HIGH), `B104` (MEDIUM) and
  `B101` (LOW). `B324` being the only HIGH severity finding is what the
  `severity-level` / `skips` test relies on, so keep that property when editing
  the fixture.
