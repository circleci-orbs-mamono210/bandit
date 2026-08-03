#!/bin/bash
bandit --version 2>&1 \
| GREP_COLORS='mt=01;34' grep -E --color=always '[[:digit:]]|^' \
| GREP_COLORS='mt=01;33' grep -E --color=always 'bandit|^'
