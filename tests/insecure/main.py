"""Fixture with deliberate bandit findings, used by the integration tests.

B324 is the only HIGH severity finding in this file. The integration tests
depend on that, so keep it that way when editing the fixture.
"""

import hashlib


def digest(value: bytes) -> str:
    """B324: MD5 is flagged as a weak hash (HIGH severity)."""
    return hashlib.md5(value).hexdigest()


def check(value: int) -> None:
    """B101: assert is stripped by python -O (LOW severity)."""
    assert value > 0


def bind() -> str:
    """B104: binding to all interfaces (MEDIUM severity)."""
    return "0.0.0.0"
