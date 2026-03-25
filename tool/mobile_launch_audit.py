from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import json


ROOT = Path(__file__).resolve().parents[1]
ANDROID_SIGNING_ENV_VARS = (
    "ANDROID_KEYSTORE_PATH",
    "ANDROID_KEYSTORE_PASSWORD",
    "ANDROID_KEY_ALIAS",
    "ANDROID_KEY_PASSWORD",
)


@dataclass
class CheckResult:
    label: str
    ok: bool
    detail: str


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def file_exists(path: str, label: str) -> CheckResult:
    target = ROOT / path
    return CheckResult(label, target.exists(), path if target.exists() else f"Missing: {path}")


def android_signing_configured() -> CheckResult:
    key_properties_path = ROOT / "android/key.properties"
    if key_properties_path.exists():
        return CheckResult(
            "Local Android release signing",
            True,
            "android/key.properties present",
        )

    missing = [
        name for name in ANDROID_SIGNING_ENV_VARS if not __import__("os").environ.get(name, "").strip()
    ]
    if not missing:
        return CheckResult(
            "Local Android release signing",
            True,
            "ANDROID_KEYSTORE_PATH / ANDROID_KEYSTORE_PASSWORD / ANDROID_KEY_ALIAS / ANDROID_KEY_PASSWORD set",
        )

    return CheckResult(
        "Local Android release signing",
        False,
        "Missing android/key.properties and signing env vars",
    )


def make_checks() -> list[CheckResult]:
    checks: list[CheckResult] = []

    checks.append(file_exists("android/key.properties.example", "Android signing template"))
    checks.append(file_exists("ios/Podfile", "iOS Podfile"))
    checks.append(file_exists("ios/Runner/PrivacyInfo.xcprivacy", "iOS privacy manifest"))
    checks.append(file_exists("web/privacy-policy.html", "Hosted privacy policy"))
    checks.append(file_exists("web/support.html", "Hosted support page"))
    checks.append(file_exists("web/terms.html", "Hosted terms page"))
    checks.append(file_exists(".github/workflows/mobile-release-validate.yml", "Mobile validation workflow"))
    checks.append(file_exists("tool/validate_mobile_release.ps1", "Local mobile validation script"))
    checks.append(file_exists("tool/validate_store_metadata.py", "Store metadata validator"))
    checks.append(file_exists("tool/stage_store_screenshots.ps1", "Screenshot staging script"))
    checks.append(file_exists("docs/mobile-launch-runbook.md", "Mobile launch runbook"))
    checks.append(file_exists("docs/store-submission-checklist.md", "Store submission checklist"))
    checks.append(file_exists("docs/device-qa-matrix.md", "Device QA matrix"))
    checks.append(android_signing_configured())
    checks.append(
        file_exists(
            "store/assets/google-play/feature-graphic/feature-graphic.png",
            "Google Play feature graphic",
        )
    )
    checks.append(file_exists("store/google-play/data-safety-notes.md", "Google Play Data safety draft"))
    checks.append(file_exists("store/google-play/app-content-notes.md", "Google Play App content draft"))
    checks.append(file_exists("store/google-play/content-rating-notes.md", "Google Play content rating draft"))
    checks.append(file_exists("store/app-store/app-privacy-notes.md", "App Store privacy draft"))
    checks.append(file_exists("store/app-store/age-rating-notes.md", "App Store age rating draft"))
    checks.append(file_exists("store/app-store/export-compliance-notes.md", "App Store export compliance draft"))

    gradle_text = read_text(ROOT / "android/app/build.gradle.kts")
    checks.append(
        CheckResult(
            "Android release signing guard",
            "Release signing is not configured" in gradle_text and 'create("release")' in gradle_text,
            "Release builds require keystore configuration" if "Release signing is not configured" in gradle_text else "Signing guard missing",
        )
    )

    manifest_text = read_text(ROOT / "android/app/src/main/AndroidManifest.xml")
    checks.append(
        CheckResult(
            "Android round icon",
            'android:roundIcon="@mipmap/ic_launcher_round"' in manifest_text,
            "round icon declared in AndroidManifest.xml" if 'android:roundIcon="@mipmap/ic_launcher_round"' in manifest_text else "round icon missing",
        )
    )

    google_play_locales = {
        "en-US": {"short-description.txt", "full-description.txt", "release-notes.txt"},
        "es-ES": {"short-description.txt", "full-description.txt", "release-notes.txt"},
        "ja-JP": {"short-description.txt", "full-description.txt", "release-notes.txt"},
        "ko-KR": {"short-description.txt", "full-description.txt", "release-notes.txt"},
        "zh-CN": {"short-description.txt", "full-description.txt", "release-notes.txt"},
    }
    app_store_locales = {
        "en-US": {"subtitle.txt", "description.txt", "keywords.txt", "promotional-text.txt", "review-notes.txt"},
        "es-ES": {"subtitle.txt", "description.txt", "keywords.txt", "promotional-text.txt", "review-notes.txt"},
        "ja": {"subtitle.txt", "description.txt", "keywords.txt", "promotional-text.txt", "review-notes.txt"},
        "ko": {"subtitle.txt", "description.txt", "keywords.txt", "promotional-text.txt", "review-notes.txt"},
        "zh-Hans": {"subtitle.txt", "description.txt", "keywords.txt", "promotional-text.txt", "review-notes.txt"},
    }

    for locale, files in google_play_locales.items():
        locale_dir = ROOT / "store/google-play" / locale
        missing = sorted(name for name in files if not (locale_dir / name).exists())
        checks.append(
            CheckResult(
                f"Google Play metadata [{locale}]",
                not missing,
                str(locale_dir) if not missing else f"Missing: {', '.join(missing)}",
            )
        )

    for locale, files in app_store_locales.items():
        locale_dir = ROOT / "store/app-store" / locale
        missing = sorted(name for name in files if not (locale_dir / name).exists())
        checks.append(
            CheckResult(
                f"App Store metadata [{locale}]",
                not missing,
                str(locale_dir) if not missing else f"Missing: {', '.join(missing)}",
            )
        )

    play_shots = list((ROOT / "store/assets/google-play/phone-screenshots").glob("*.png"))
    iphone_shots = list((ROOT / "store/assets/app-store/iphone-screenshots").glob("*.png"))
    checks.append(
        CheckResult(
            "Draft Google Play screenshots",
            len(play_shots) >= 4,
            f"{len(play_shots)} PNG files staged",
        )
    )
    checks.append(
        CheckResult(
            "Draft App Store iPhone screenshots",
            len(iphone_shots) >= 4,
            f"{len(iphone_shots)} PNG files staged",
        )
    )

    return checks


def build_markdown(checks: list[CheckResult]) -> str:
    passed = sum(1 for check in checks if check.ok)
    total = len(checks)
    lines = [
        "# Mobile Launch Audit",
        "",
        f"- Passed checks: {passed}/{total}",
        "",
        "## Checklist",
        "",
    ]

    for check in checks:
        marker = "[x]" if check.ok else "[ ]"
        lines.append(f"- {marker} {check.label}: {check.detail}")

    lines.extend(
        [
            "",
            "## Remaining External Work",
            "",
            "- Configure the permanent Android upload keystore and Play App Signing",
            "- Run macOS/Xcode archive, codesigning, TestFlight, and App Store Connect validation",
            "- Replace staged draft screenshots with real-device final store captures",
            "- Submit final console questionnaires after checking the actual archived binaries",
        ]
    )
    return "\n".join(lines) + "\n"


def build_json(checks: list[CheckResult]) -> dict:
    return {
        "passed": sum(1 for check in checks if check.ok),
        "total": len(checks),
        "checks": [
            {
                "label": check.label,
                "ok": check.ok,
                "detail": check.detail,
            }
            for check in checks
        ],
    }


def main() -> int:
    checks = make_checks()
    report_dir = ROOT / "output/mobile_launch_audit"
    report_dir.mkdir(parents=True, exist_ok=True)

    markdown = build_markdown(checks)
    report_path = report_dir / "launch_readiness_report.md"
    report_path.write_text(markdown, encoding="utf-8")

    json_path = report_dir / "launch_readiness_report.json"
    json_path.write_text(json.dumps(build_json(checks), indent=2), encoding="utf-8")

    print(markdown, end="")
    print(f"\nWrote {report_path}")
    print(f"Wrote {json_path}")
    return 0 if all(check.ok for check in checks) else 1


if __name__ == "__main__":
    raise SystemExit(main())
