# Release Readiness Notes

## What This Change Solves

- Track selection now has real differentiation through unique chapters, generation presets, expectation copy, and sound profiles.
- Study Harmony shows learning content earlier by moving chapter cards above league-heavy meta panels.
- Analyzer, Practice, and Study Harmony now share a structured explanation surface.
- Explanation cards now surface confidence tone, ambiguity guidance, competing readings, and track-aware listening/performance cues instead of only a short summary.
- Progress storage now has a versioned v2 envelope, backup recovery, and legacy migration on top of `SharedPreferences`.
- Study Harmony hub meta copy now comes from ARB-backed localization keys instead of page-local language branches.
- Session reward/meta labels, advanced melody settings copy, and analyzer placeholder wording now route through ARB keys instead of local hardcoded strings.
- Tests now cover track integrity, explanation mapping, and progress recovery paths more directly.

## Remaining Risks

- `study_harmony_page.dart` is still very large even after the recent hub extraction, so copy and meta sections should be split again.
- The v2 progress system still uses `SharedPreferences`; this is safer than before, but not a long-term sync-capable store.
- Reward, shop, and arcade catalog data still rely on canonical catalog copy in some locales instead of a fully localized catalog pipeline.
- The new explanation keys are localized in Korean, but `es/ja/zh` still use English fallback copy for the newly added explanation strings.
- Sound profiles are currently placeholders over a shared piano asset rather than fully distinct playback assets.

## Next Recommended Work

1. Split `study_harmony_page.dart` into landing widgets so copy, hierarchy, and meta systems can evolve safely.
2. Localize the remaining reward/shop/arcade catalog payloads instead of relying on fallback catalog copy.
3. Add more generator explanation signals from smart-generator diagnostics, but only after curating user-safe reason codes.
4. Consider a future repository backend that can support partial writes and cloud sync.
5. Add more widget coverage around session feedback explanations and practice explanation states.
