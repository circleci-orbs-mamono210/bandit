"""Clean fixture used by the Bandit Orb integration tests."""

import hashlib


def generate_secure_digest(value: str) -> str:
    """Generate a SHA-256 digest."""
    return hashlib.sha256(value.encode("utf-8")).hexdigest()
