#!/bin/bash
set -eo pipefail

PACKAGE='bandit'

if [ -n "${PARAM_EXTRAS}" ]; then
  PACKAGE="${PACKAGE}[${PARAM_EXTRAS}]"
fi

if [ -n "${PARAM_VERSION}" ]; then
  PACKAGE="${PACKAGE}==${PARAM_VERSION}"
fi

echo "Installing ${PACKAGE}"
pip install --upgrade "${PACKAGE}"
