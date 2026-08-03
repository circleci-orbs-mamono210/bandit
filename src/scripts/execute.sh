#!/bin/bash
set -eo pipefail

BANDIT_ARGS=()

if [ "${PARAM_RECURSIVE}" = 'true' ]; then
  BANDIT_ARGS+=('--recursive')
fi

if [ -n "${PARAM_CONFIG_FILE}" ]; then
  BANDIT_ARGS+=('--configfile' "${PARAM_CONFIG_FILE}")
fi

if [ -n "${PARAM_INI_PATH}" ]; then
  BANDIT_ARGS+=('--ini' "${PARAM_INI_PATH}")
fi

if [ "${PARAM_SEVERITY_LEVEL}" != 'all' ]; then
  BANDIT_ARGS+=('--severity-level' "${PARAM_SEVERITY_LEVEL}")
fi

if [ "${PARAM_CONFIDENCE_LEVEL}" != 'all' ]; then
  BANDIT_ARGS+=('--confidence-level' "${PARAM_CONFIDENCE_LEVEL}")
fi

if [ -n "${PARAM_TESTS}" ]; then
  BANDIT_ARGS+=('--tests' "${PARAM_TESTS}")
fi

if [ -n "${PARAM_SKIPS}" ]; then
  BANDIT_ARGS+=('--skip' "${PARAM_SKIPS}")
fi

if [ -n "${PARAM_EXCLUDED_PATHS}" ]; then
  BANDIT_ARGS+=('--exclude' "${PARAM_EXCLUDED_PATHS}")
fi

if [ -n "${PARAM_BASELINE}" ]; then
  BANDIT_ARGS+=('--baseline' "${PARAM_BASELINE}")
fi

BANDIT_ARGS+=('--format' "${PARAM_FORMAT}")

if [ -n "${PARAM_OUTPUT_FILE}" ]; then
  mkdir -p "$(dirname "${PARAM_OUTPUT_FILE}")"
  BANDIT_ARGS+=('--output' "${PARAM_OUTPUT_FILE}")
fi

if [ "${PARAM_EXIT_ZERO}" = 'true' ]; then
  BANDIT_ARGS+=('--exit-zero')
fi

# Word splitting is intended here, extra-args may hold several flags.
# shellcheck disable=SC2206
if [ -n "${PARAM_EXTRA_ARGS}" ]; then
  BANDIT_ARGS+=(${PARAM_EXTRA_ARGS})
fi

# Word splitting is intended here, targets may hold several paths.
# shellcheck disable=SC2206
TARGETS=(${PARAM_TARGETS})

echo "bandit ${BANDIT_ARGS[*]} ${TARGETS[*]}"
bandit "${BANDIT_ARGS[@]}" "${TARGETS[@]}"
