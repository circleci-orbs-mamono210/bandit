#!/bin/bash
set -eo pipefail

BANDIT_ARGS=()

is_true() {
  case "${1,,}" in
    true | 1 | yes | on)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

if is_true "${PARAM_RECURSIVE}"; then
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

if is_true "${PARAM_EXIT_ZERO}"; then
  BANDIT_ARGS+=('--exit-zero')
fi

EXTRA_ARGS=()
if [ -n "${PARAM_EXTRA_ARGS}" ]; then
  while read -r -a LINE_ARGS; do
    EXTRA_ARGS+=("${LINE_ARGS[@]}")
  done <<< "${PARAM_EXTRA_ARGS}"

  BANDIT_ARGS+=("${EXTRA_ARGS[@]}")
fi

TARGETS=()
while read -r -a LINE_TARGETS; do
  TARGETS+=("${LINE_TARGETS[@]}")
done <<< "${PARAM_TARGETS}"

printf 'PARAM_RECURSIVE=%q\n' "${PARAM_RECURSIVE}"
printf 'PARAM_EXIT_ZERO=%q\n' "${PARAM_EXIT_ZERO}"
printf 'Command:'
printf ' %q' bandit "${BANDIT_ARGS[@]}" "${TARGETS[@]}"
printf '\n'

bandit "${BANDIT_ARGS[@]}" "${TARGETS[@]}"
