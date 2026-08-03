"""Fixture without any bandit findings, used by the integration tests.

Keep this file free of findings: the command tests assert that bandit
exits 0 when it is scanned with the default parameters.
"""

import hashlib
import json


def digest(value: bytes) -> str:
    """Hash a value with an algorithm bandit is happy with."""
    return hashlib.sha256(value).hexdigest()


def load(path: str) -> dict:
    """Read a JSON document from disk."""
    with open(path, encoding="utf-8") as handle:
        return json.load(handle)
