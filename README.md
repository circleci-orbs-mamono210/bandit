# Bandit Orb

[![CircleCI Build Status](https://circleci.com/gh/circleci-orbs-mamono210/bandit.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/circleci-orbs-mamono210/bandit)
[![CircleCI Orb Version](https://badges.circleci.com/orbs/orbss/bandit.svg)](https://circleci.com/orbs/registry/orb/orbss/bandit)
[![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)

A CircleCI Orb for running [Bandit](https://bandit.readthedocs.io/), a security linter for Python source code.

This Orb provides:

* A command for installing Bandit with `pip`
* A command for executing Bandit
* A configurable Python executor
* Severity and confidence filtering
* Test inclusion and exclusion
* Baseline comparison
* JSON, SARIF, HTML, XML and other report formats
* Support for Bandit configuration files and `pyproject.toml`

## Orb Registry

The published Orb, parameter reference and generated examples are available in the CircleCI Orb Registry:

https://circleci.com/developer/orbs/orb/orbss/bandit

## Quick Start

The default executor uses a CircleCI Python convenience image. Bandit is not preinstalled, so run `bandit/install` before `bandit/execute`.

```yaml
version: 2.1

orbs:
  bandit: orbss/bandit@x.y.z

jobs:
  execute-bandit:
    executor: bandit/default
    steps:
      - checkout
      - bandit/install
      - bandit/execute

workflows:
  bandit:
    jobs:
      - execute-bandit
```

Replace `x.y.z` with the Orb version to use.

By default, Bandit scans the current working directory recursively. The job fails when Bandit reports a finding.

## Using an Existing Executor

The commands can be used with an existing Docker executor. Run `bandit/install` when the selected image does not already provide Bandit.

```yaml
version: 2.1

orbs:
  bandit: orbss/bandit@x.y.z

jobs:
  execute-bandit:
    docker:
      - image: cimg/python:3.13
    steps:
      - checkout
      - bandit/install:
          version: "1.9.4"
      - bandit/execute:
          targets: src

workflows:
  bandit:
    jobs:
      - execute-bandit
```

Specifying a Bandit version makes the scan environment reproducible. When `version` is empty, the latest available Bandit release is installed.

## Configuration with pyproject.toml

Install Bandit with the `toml` extra when reading configuration from `pyproject.toml`.

Example `pyproject.toml`:

```toml
[tool.bandit]
exclude_dirs = ["tests", ".venv"]
skips = ["B101"]
```

CircleCI configuration:

```yaml
version: 2.1

orbs:
  bandit: orbss/bandit@x.y.z

jobs:
  execute-bandit:
    docker:
      - image: cimg/python:3.13
    steps:
      - checkout
      - bandit/install:
          extras: toml
          version: "1.9.4"
      - bandit/execute:
          config-file: pyproject.toml

workflows:
  bandit:
    jobs:
      - execute-bandit
```

Multiple installation extras can be supplied as a comma-separated string.

```yaml
- bandit/install:
    extras: toml,sarif
```

## Scanning Selected Paths

Use `targets` to select files or directories.

```yaml
- bandit/execute:
    targets: src app scripts
```

Targets are supplied as a whitespace-separated string. Spaces, tabs and newlines are treated as argument separators. The Orb splits the value into individual target arguments without performing shell pathname expansion.

For example, targets can be written across multiple lines using a YAML block scalar:

```yaml
- bandit/execute:
    targets: |
      src
      app
      scripts
```

This is passed to Bandit as three separate targets.

Shell quoting inside the `targets` value is not evaluated. As a result, a path containing whitespace cannot be represented as a single target with this parameter.

Glob-like characters such as `*`, `?` and `[]` are passed to Bandit literally rather than being expanded by the shell.

Use `recursive: false` when scanning a single file without recursive directory traversal.

```yaml
- bandit/execute:
    recursive: false
    targets: src/example.py
```

## Excluding Paths

Use `excluded-paths` to exclude directories or files from the scan.

```yaml
- bandit/execute:
    excluded-paths: tests,.venv,build
    targets: .
```

The value is passed to Bandit's `--exclude` option as a comma-separated list.

## Severity and Confidence Gates

Use `severity-level` and `confidence-level` to control which findings fail the job.

```yaml
- bandit/execute:
    confidence-level: medium
    severity-level: medium
    targets: src
```

Supported levels are:

* `all`
* `low`
* `medium`
* `high`

The default value is `all`.

For example, the following configuration fails only when Bandit reports findings with both medium-or-higher severity and medium-or-higher confidence.

```yaml
- bandit/execute:
    confidence-level: medium
    severity-level: medium
```

## Selecting or Skipping Tests

Use `tests` to run only selected Bandit checks.

```yaml
- bandit/execute:
    tests: B301,B324
    targets: src
```

Use `skips` to disable selected checks.

```yaml
- bandit/execute:
    skips: B101,B601
    targets: src
```

The values are passed as comma-separated Bandit test IDs.

## Saving a JSON Report

Use `format` and `output-file` to create a machine-readable report.

The parent directory of `output-file` is created automatically.

```yaml
version: 2.1

orbs:
  bandit: orbss/bandit@x.y.z

jobs:
  execute-bandit:
    executor: bandit/default
    steps:
      - checkout
      - bandit/install

      - bandit/execute:
          excluded-paths: tests,.venv
          exit-zero: true
          format: json
          output-file: reports/bandit.json
          targets: .

      - store_artifacts:
          path: reports

workflows:
  bandit:
    jobs:
      - execute-bandit
```

`exit-zero: true` prevents the reporting step from stopping the job when findings are detected. This allows CircleCI to store the generated report.

Supported report formats are:

* `csv`
* `custom`
* `html`
* `json`
* `sarif`
* `screen`
* `txt`
* `xml`
* `yaml`

The `sarif` format requires Bandit to be installed with the `sarif` extra.

## Saving a SARIF Report

Bandit's SARIF formatter uses optional dependencies. Install Bandit with the `sarif` extra before using `format: sarif`.

```yaml
version: 2.1

orbs:
  bandit: orbss/bandit@x.y.z

jobs:
  execute-bandit:
    executor: bandit/default
    steps:
      - checkout

      - bandit/install:
          extras: sarif
          version: "1.9.4"

      - bandit/execute:
          exit-zero: true
          format: sarif
          output-file: reports/bandit.sarif
          targets: src

      - store_artifacts:
          path: reports

workflows:
  bandit:
    jobs:
      - execute-bandit
```

The generated file uses SARIF 2.1.0 and can be consumed by tools that support SARIF reports.

## Saving a Report and Enforcing a Quality Gate

When both report storage and job failure are required, run Bandit twice.

The first execution generates and stores the report. The second execution enforces the quality gate.

```yaml
version: 2.1

orbs:
  bandit: orbss/bandit@x.y.z

jobs:
  execute-bandit:
    executor: bandit/default
    steps:
      - checkout
      - bandit/install

      - bandit/execute:
          excluded-paths: tests,.venv
          exit-zero: true
          format: json
          output-file: reports/bandit.json

      - store_artifacts:
          path: reports

      - bandit/execute:
          confidence-level: medium
          excluded-paths: tests,.venv
          severity-level: medium

workflows:
  bandit:
    jobs:
      - execute-bandit
```

The first scan always exits successfully after producing the report. The second scan determines whether the CircleCI job passes or fails.

## Baseline Comparison

Use `baseline` to report findings that are not present in an existing Bandit JSON report.

```yaml
- bandit/execute:
    baseline: bandit-baseline.json
    format: json
    targets: src
```

The baseline file must be available in the job workspace before the command runs.

## Using a Bandit Configuration File

Use `config-file` to supply a YAML, TOML or other Bandit-supported configuration file.

```yaml
- bandit/execute:
    config-file: bandit.yaml
    targets: src
```

Use `ini-path` to supply a `.bandit` INI file.

```yaml
- bandit/execute:
    ini-path: .bandit
    targets: src
```

## Commands

### `bandit/install`

Installs Bandit using `pip`.

Parameters:

| Parameter | Type   | Default | Description                                                  |
| --------- | ------ | ------: | ------------------------------------------------------------ |
| `extras`  | string |    `""` | Comma-separated pip extras, such as `toml` or `sarif`        |
| `version` | string |    `""` | Bandit version to install; empty installs the latest release |

Example:

```yaml
- bandit/install:
    extras: toml
    version: "1.9.4"
```

### `bandit/execute`

Runs Bandit against the selected source files or directories.

Parameters:

| Parameter          | Type    |  Default | Description                                      |
| ------------------ | ------- | -------: | ------------------------------------------------ |
| `baseline`         | string  |     `""` | JSON baseline report                             |
| `confidence-level` | enum    |    `all` | Minimum confidence level                         |
| `config-file`      | string  |     `""` | Bandit configuration file                        |
| `excluded-paths`   | string  |     `""` | Comma-separated excluded paths                   |
| `exit-zero`        | boolean |  `false` | Exit successfully when findings are reported     |
| `extra-args`       | string  |     `""` | Additional whitespace-separated Bandit arguments |
| `format`           | enum    | `screen` | Report format                                    |
| `ini-path`         | string  |     `""` | Path to a `.bandit` file                         |
| `output-file`      | string  |     `""` | Report output path                               |
| `recursive`        | boolean |   `true` | Recursively scan directories                     |
| `severity-level`   | enum    |    `all` | Minimum severity level                           |
| `skips`            | string  |     `""` | Comma-separated test IDs to skip                 |
| `targets`          | string  |      `.` | Whitespace-separated files or directories        |
| `tests`            | string  |     `""` | Comma-separated test IDs to run                  |

Options not directly exposed by the Orb can be passed with `extra-args`.

```yaml
- bandit/execute:
    extra-args: "--verbose --quiet"
    targets: src
```

`extra-args` is split on whitespace and passed to Bandit as separate arguments. Spaces, tabs and newlines are accepted as separators. Shell pathname expansion is not performed.

For example, arguments can be written across multiple lines:

```yaml
- bandit/execute:
    extra-args: |
      --severity-level high
      --skip B324
    targets: src
```

This passes `--severity-level`, `high`, `--skip` and `B324` as four separate Bandit command-line arguments.

Shell quoting inside `extra-args` is not evaluated. Therefore, an option that requires one argument containing whitespace cannot be represented through `extra-args`.

For commonly used Bandit options, prefer the dedicated Orb parameters when available.

## Executor

### `bandit/default`

A configurable CircleCI Python executor for running Bandit.

Bandit is not preinstalled. Run `bandit/install` before `bandit/execute`.

Parameters:

| Parameter        | Type   |            Default | Description                       |
| ---------------- | ------ | -----------------: | --------------------------------- |
| `image`          | string | `cimg/python:3.14` | Docker image used by the executor |
| `resource_class` | enum   |            `small` | CircleCI resource class           |

Supported resource classes are:

* `small`
* `medium`
* `medium+`
* `large`

Example:

```yaml
executor:
  name: bandit/default
  image: cimg/python:3.13
  resource_class: medium
```

## Development

The Orb source is stored under `src/` in unpacked Orb format.

The CircleCI pipeline performs:

* Orb linting
* Orb packing
* Orb review
* ShellCheck
* Integration tests
* Production publishing from semantic version tags

Production releases use tags in the following format:

```text
v1.2.3
```

## License

This project is released under the [MIT License](LICENSE).
