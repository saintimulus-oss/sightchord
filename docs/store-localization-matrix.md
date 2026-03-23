# Store Localization Matrix

This matrix maps app UI locales to the store metadata locales we expect to maintain for launch.

| App locale | Google Play locale | App Store locale | Current repo status |
| --- | --- | --- | --- |
| `en` | `en-US` | `en-US` | Draft metadata present |
| `es` | `es-ES` | `es-ES` | Draft metadata present |
| `ja` | `ja-JP` | `ja` | Draft metadata present |
| `ko` | `ko-KR` | `ko` | Draft metadata present |
| `zh_Hans` | `zh-CN` | `zh-Hans` | Draft metadata present |

## Notes

- The app already exposes English, Spanish, Japanese, Korean, and Simplified Chinese UI.
- Store metadata should ideally match the launch locales that are visible in the app.
- Use `tool/validate_store_locale_coverage.py` to generate the latest repo-based coverage report.
