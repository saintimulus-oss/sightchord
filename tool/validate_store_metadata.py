from __future__ import annotations

from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]

LIMIT_GROUPS = (
    ("store/google-play", "short-description.txt", 80, "Google Play short description"),
    ("store/app-store", "subtitle.txt", 30, "App Store subtitle"),
    ("store/app-store", "keywords.txt", 100, "App Store keywords"),
    ("store/app-store", "promotional-text.txt", 170, "App Store promotional text"),
)


def main() -> int:
    has_error = False

    for root, filename, limit, label in LIMIT_GROUPS:
        locale_root = ROOT / root
        for locale_dir in sorted(path for path in locale_root.iterdir() if path.is_dir()):
            path = locale_dir / filename
            if not path.exists():
                continue

            text = path.read_text(encoding="utf-8").strip()
            length = len(text)
            status = "OK" if length <= limit else "TOO LONG"
            print(f"{label} [{locale_dir.name}]: {length}/{limit} chars [{status}]")
            if length > limit:
                has_error = True

    if has_error:
        print("One or more metadata fields exceed platform limits.", file=sys.stderr)
        return 1

    print("All checked metadata fields are within the configured limits.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
