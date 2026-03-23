from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import json


ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = ROOT / "output" / "mobile_launch_audit"

EXPECTED = {
    "en": {"google_play": "en-US", "app_store": "en-US"},
    "es": {"google_play": "es-ES", "app_store": "es-ES"},
    "ja": {"google_play": "ja-JP", "app_store": "ja"},
    "ko": {"google_play": "ko-KR", "app_store": "ko"},
    "zh_Hans": {"google_play": "zh-CN", "app_store": "zh-Hans"},
}

REQUIRED_FILES = {
    "google_play": {"short-description.txt", "full-description.txt", "release-notes.txt"},
    "app_store": {
        "subtitle.txt",
        "description.txt",
        "keywords.txt",
        "promotional-text.txt",
        "review-notes.txt",
    },
}


@dataclass
class LocaleCoverage:
    app_locale: str
    google_play_locale: str
    app_store_locale: str
    google_play_complete: bool
    app_store_complete: bool
    google_play_missing: list[str]
    app_store_missing: list[str]


def app_locales() -> list[str]:
    locales = []
    for path in sorted((ROOT / "lib/l10n").glob("app_*.arb")):
        stem = path.stem.removeprefix("app_")
        if stem in EXPECTED:
            locales.append(stem)
    return locales


def missing_files(base: Path, names: set[str]) -> list[str]:
    return sorted(name for name in names if not (base / name).exists())


def build_rows() -> list[LocaleCoverage]:
    rows: list[LocaleCoverage] = []
    for locale in app_locales():
        mapping = EXPECTED[locale]
        gp_dir = ROOT / "store/google-play" / mapping["google_play"]
        as_dir = ROOT / "store/app-store" / mapping["app_store"]
        gp_missing = missing_files(gp_dir, REQUIRED_FILES["google_play"])
        as_missing = missing_files(as_dir, REQUIRED_FILES["app_store"])
        rows.append(
            LocaleCoverage(
                app_locale=locale,
                google_play_locale=mapping["google_play"],
                app_store_locale=mapping["app_store"],
                google_play_complete=not gp_missing,
                app_store_complete=not as_missing,
                google_play_missing=gp_missing,
                app_store_missing=as_missing,
            )
        )
    return rows


def markdown(rows: list[LocaleCoverage]) -> str:
    lines = [
        "# Store Locale Coverage",
        "",
        "| App locale | Google Play | App Store | Status |",
        "| --- | --- | --- | --- |",
    ]
    for row in rows:
        statuses = []
        statuses.append("GP ok" if row.google_play_complete else f"GP missing: {', '.join(row.google_play_missing)}")
        statuses.append("AS ok" if row.app_store_complete else f"AS missing: {', '.join(row.app_store_missing)}")
        lines.append(
            f"| `{row.app_locale}` | `{row.google_play_locale}` | `{row.app_store_locale}` | {'; '.join(statuses)} |"
        )
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    rows = build_rows()
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    md_path = OUTPUT_DIR / "store_locale_coverage.md"
    json_path = OUTPUT_DIR / "store_locale_coverage.json"
    md_path.write_text(markdown(rows), encoding="utf-8")
    json_path.write_text(
        json.dumps(
            [
                {
                    "app_locale": row.app_locale,
                    "google_play_locale": row.google_play_locale,
                    "app_store_locale": row.app_store_locale,
                    "google_play_complete": row.google_play_complete,
                    "app_store_complete": row.app_store_complete,
                    "google_play_missing": row.google_play_missing,
                    "app_store_missing": row.app_store_missing,
                }
                for row in rows
            ],
            indent=2,
        ),
        encoding="utf-8",
    )
    print(md_path.read_text(encoding="utf-8"), end="")
    print(f"\nWrote {md_path}")
    print(f"Wrote {json_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
