# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.8] - 2026-08-10

### Added

* Added an integration test for the `config-file` parameter to verify that a Bandit YAML configuration file is loaded and its `skips` setting is applied.
* Added an integration test for the `baseline` parameter to verify that findings already present in a Bandit JSON baseline report are ignored.
* Added an integration test for the `ini-path` parameter to verify that a Bandit INI configuration file is loaded and its `skips` setting is applied.
* Added an integration test for the `confidence-level` parameter to verify that findings below the configured confidence threshold are filtered out.
* Added an integration test for the `extra-args` parameter to verify that multiple additional Bandit CLI arguments are forwarded and applied correctly.
* Added an integration test for the `tests` parameter to verify that Bandit runs only the selected test IDs.

## [0.0.7] - 2026-08-09

### Added

* Added this changelog.
* Expanded the README with the Orb registry link, a quick start, and parameter documentation for `bandit/install`, `bandit/execute` and `bandit/default`.

### Changed

* Changed the Bandit installation command from `pip install` to `python -m pip install` so pip is executed with the selected Python interpreter.
* Changed the production publishing job to use the `CIRCLECI_ORBS` context, instead of the `<publishing-context>` placeholder left in place by the Orb development kit.
* Consolidated the integration-test fixtures into files under `tests/`, instead of generating them from heredocs inside each job.

## [0.0.6] - 2026-08-05

### Changed

* Clarified the `bandit/default` executor description to state that Bandit is not preinstalled and that `bandit/install` has to run before `bandit/execute`.

### Fixed

* Fixed the organisation name placeholder left in `LICENSE`.

## [0.0.5] - 2026-08-03

### Added

* Added a verification step to the integration tests that parses the Bandit JSON report and asserts that no scan errors were reported, that at least one source line was scanned, and that `B324` is present in the findings.
* Added a clean fixture that Bandit is expected to pass, so a passing scan is covered as well as a failing one.

### Changed

* Accepted `1`, `yes` and `on`, in any letter case, as true values for the `exit-zero` and `recursive` parameters.
* Replaced the plain command echo in `src/scripts/execute.sh` with a `printf '%q'` trace that shows the resolved Bandit invocation together with the received `recursive` and `exit-zero` values, so a quoting problem is visible in the CircleCI log.
* Changed the integration tests to scan explicit file paths with `recursive: false`, instead of relying on recursive discovery over the checked-out `tests` directory.
* Pinned the Bandit version installed by the integration tests to 1.9.4.

## [0.0.4] - 2026-08-03

### Fixed

* Added `bandit/install` to the default and report usage examples, which previously ran `bandit/execute` on an executor that does not ship Bandit.

## [0.0.3] - 2026-08-03

### Changed

* Rewrote the Orb description in `src/@orb.yml` so it describes the install and execute commands and the configurable Python executor, instead of referring to a `ghcr.io` executor image that the Orb does not use.

## [0.0.2] - 2026-08-03

Initial release of the Bandit CircleCI Orb.

### Added

* Added the `bandit/install` command for installing Bandit with `pip`.
* Added the `bandit/execute` command for running Bandit against Python source code.
* Added the configurable `bandit/default` Python executor, with `image` and `resource_class` parameters.
* Added `extras` support so Bandit can be installed with pip extras such as `toml`.
* Added `version` support for pinning the installed Bandit release.
* Added severity and confidence filtering with `severity-level` and `confidence-level`.
* Added test selection and exclusion with `tests` and `skips`.
* Added path controls with `targets`, `excluded-paths` and `recursive`.
* Added configuration file support with `config-file` and `ini-path`, including `pyproject.toml` by way of the `toml` extra.
* Added `baseline` support for reporting only findings that are new relative to an existing JSON report.
* Added report format selection with `format`, covering `csv`, `custom`, `html`, `json`, `screen`, `txt`, `xml` and `yaml`.
* Added `output-file` support for saving the Bandit report as a CircleCI artifact.
* Added `exit-zero` support for report-generation steps that should not fail when findings are present.
* Added `extra-args` for Bandit command-line options that are not exposed directly by the Orb.
* Added a version reporting step that prints the Bandit version before each scan.
* Added examples for scanning, installation and artifact reporting.
* Added integration tests covering commands, parameters, installation and executor resource classes.
* Added Orb linting, packing, review and ShellCheck to the development pipeline.
* Added production publishing from Semantic Versioning tags.

[Unreleased]: https://github.com/circleci-orbs-mamono210/bandit/compare/v0.0.8...HEAD
[0.0.8]: https://github.com/circleci-orbs-mamono210/bandit/compare/v0.0.7...v0.0.8
[0.0.7]: https://github.com/circleci-orbs-mamono210/bandit/compare/v0.0.6...v0.0.7
[0.0.6]: https://github.com/circleci-orbs-mamono210/bandit/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/circleci-orbs-mamono210/bandit/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/circleci-orbs-mamono210/bandit/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/circleci-orbs-mamono210/bandit/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/circleci-orbs-mamono210/bandit/releases/tag/v0.0.2

