# Android Commercialization Roadmap

## Goal

Reach a first commercial Android release on Google Play with:

- a production-ready Android build,
- one clear monetization path,
- enough policy and support readiness to take payments safely, and
- a repeatable release process that can later be reused for iOS.

## Current Snapshot

As of 2026-03-13, the codebase is technically healthy but not yet store-ready.

Validated locally:

- `flutter analyze` passes.
- `flutter test` passes.
- `flutter build appbundle --release` succeeds.
- The generated Android App Bundle is `build/app/outputs/bundle/release/app-release.aab` at about `42.0 MB`.

Important gaps found in the repo:

- Android now uses the shared app ID `io.github.saintimulusoss.chordest`, but release signing still needs owner provisioning.
- The Android release build is still signed with the debug signing config.
- The app version is still `1.0.0+1`.
- The current dependency set does not include Play Billing, ads, analytics, crash reporting, auth, or backend sync.
- Study Harmony already exposes locked future tracks (`pop`, `jazz`, `classical`) and a coming-soon placeholder, which is a strong future monetization surface.
- User settings and Study Harmony progress are stored locally with `shared_preferences`, so progress will not automatically follow users across devices.
- I did not find privacy policy, support, or terms content in the repository.

## Recommended Monetization Model for Android v1

### Recommendation

Ship Android v1 with a single non-consumable premium unlock using Google Play Billing.

Why this is the best fit for the current app:

- The app is mainly offline and local-first.
- There is no account system yet.
- There is no server-delivered recurring content yet.
- A music-practice app is more likely to frustrate users with ads than benefit from them.
- A subscription would add support, restore, retention, and product-pressure overhead before the app has a recurring content pipeline.

### Suggested product shape

Keep free:

- chord generator,
- chord analyzer,
- the current core Study Harmony track.

Sell as premium:

- at least one actually shipped premium feature set at launch, such as:
  - an advanced Study Harmony pack, or
  - advanced generator/practice tooling, or
  - both bundled as a single unlock.

Do not charge for "coming soon" alone. A paid product should unlock something concrete on day one.

### What to avoid for v1

- Ads in lesson or practice flows.
- Subscription billing before there is recurring premium content.
- Multiple SKUs at launch.
- Cross-device promises before sync exists.

## Delivery Plan

## Phase 0: Product Decisions

Target duration: 1 to 2 days

Outputs:

- canonical Android package name,
- final developer account type decision,
- first monetization SKU definition,
- first-launch country list,
- public support contact,
- pricing hypothesis.

Owner tasks:

- Decide the canonical package name, for example `com.<brand>.sightchord`.
- Decide whether the Play Console account should be Personal or Organization.
- Decide whether Android v1 monetization is:
  - free app + one-time premium unlock, or
  - paid app with no in-app purchase for the first release.
- Choose launch countries.
- Create or confirm the support email address that will be shown on Google Play.

Notes:

- If the developer account is a personal account created after 2023-11-13, Google Play currently requires a closed test with at least 12 opted-in testers for 14 continuous days before production access can be requested.
- Paid apps and apps with in-app purchases require account and payments setup that should be finalized before coding the last mile of billing.

## Phase 1: Android Production Hardening

Target duration: 2 to 4 days

Outputs:

- production package name,
- release signing setup,
- release-ready app identity,
- repeatable release build commands,
- internal test build.

Tasks I can do:

- Replace placeholder Android package identifiers in code and Gradle files.
- Add production signing configuration that reads from local secure properties instead of hardcoding secrets.
- Prepare release build documentation and a checklist.
- Add Android-specific release notes and build instructions to `docs/`.
- Add optional environment split support if we want separate dev/test/prod behavior.

Tasks you need to do:

- Generate and securely back up the upload keystore or decide how you want Play App Signing managed.
- Keep keystore passwords and recovery material in your own password manager or secure storage.
- Decide the final app name, icon set, screenshots, feature graphic, and short/long store description.

Success criteria:

- production package ID is no longer placeholder,
- release build no longer uses debug signing,
- internal test AAB is generated from the production signing path,
- store metadata is ready enough to create the Play app entry.

## Phase 2: Monetization Implementation

Target duration: 3 to 6 days

Outputs:

- one Play Billing SKU,
- premium entitlement model,
- paywall / upgrade entry points,
- purchase restore flow,
- QA-tested billing behavior.

Tasks I can do:

- Integrate Flutter Play Billing via the current Flutter plugin ecosystem.
- Create a simple entitlement layer for premium access.
- Gate premium UI safely and consistently.
- Add purchase restore handling.
- Add failure, cancellation, pending purchase, and offline states.
- Add tests for entitlement behavior where practical.
- Add a billing QA checklist for license testers and closed testing.

Recommended premium entry points:

- a premium CTA in the Study Harmony hub,
- a premium CTA on locked future tracks,
- a settings/about upgrade entry point,
- optional premium badges on premium-only actions.

Product caution:

- because progress is local-only today, purchase restore and progress restore are different things.
- users should be able to restore their premium entitlement, but we should not imply that lesson progress syncs unless that is also built.

## Phase 3: Policy, Trust, and Operations

Target duration: 2 to 4 days

Outputs:

- privacy policy,
- in-app legal/support surfaces,
- Play Console declarations prepared,
- launch support plan.

Tasks I can do:

- Add an in-app About / Support / Legal screen.
- Add links for privacy policy and support contact in the app.
- Draft the repository-side policy checklist and the exact disclosures the app will need.
- If you want, prepare a privacy policy starter draft based on the app's actual data behavior.

Tasks you need to do:

- Host the privacy policy at a public, non-PDF URL.
- Fill in the Play Console Data safety form.
- Fill in app content declarations, target audience, category, and content rating.
- If using paid distribution or in-app purchases, ensure the developer profile contains the required public business/contact details.
- Decide the refund and support handling process.

Important notes:

- Even apps that do not collect user data still need a privacy policy and a completed Data safety form for Play.
- If we later add account creation, account deletion requirements also apply.

## Phase 4: Testing, Production Access, and Launch

Target duration: 2 to 3 weeks depending on account type

Outputs:

- internal testing release,
- closed testing release,
- production access approval if required,
- staged rollout plan,
- first commercial launch.

Recommended rollout sequence:

1. Internal test with you and a very small trusted group.
2. Closed test with billing license testers.
3. If required by the account type, finish the production-access testing requirement.
4. Production rollout in stages such as 5%, 20%, 50%, 100%.

Tasks I can do:

- Prepare the build and release checklist.
- Fix issues found during testing.
- Tune paywall copy and entitlement handling.
- Prepare a launch-day validation checklist.

Tasks you need to do:

- Recruit and manage testers in Play Console.
- Share tester opt-in links and collect feedback.
- Submit the production access application when Play enables it.
- Upload final store assets and finalize pricing.
- Approve the production rollout.

## Work Split

## I Can Own

- Android package ID and release-configuration refactor.
- Play Billing integration and entitlement logic.
- Paywall and locked-feature UX.
- In-app support/legal surfaces.
- Documentation, QA checklists, and release instructions.
- Build verification and production-candidate packaging.

## You Need to Own

- Play Console account creation and verification.
- Payments profile setup and tax/payout onboarding.
- Final package name and brand identity decisions.
- Signing-key custody and secure backup.
- Pricing, countries, and business policy decisions.
- Public privacy policy hosting.
- Store listing assets and marketing copy approval.
- Tester recruitment and console-side release actions.

## Risks to Watch

### 1. Placeholder Android identity

This must be fixed before store submission. It also affects long-term brand consistency and, with newer Play verification flows, can affect package-name ownership handling.

### 2. Local-only progress

Premium access can be restored through Play Billing, but user learning progress is still device-local. That is acceptable for v1 if communicated carefully, but it is a retention and support risk.

### 3. No operational telemetry yet

A commercial app without crash visibility is hard to support. We should strongly consider adding crash reporting before production even if we keep analytics minimal.

### 4. Audio/content growth

The current AAB size is acceptable, but the piano sample library is already one of the heaviest product assets. Future premium packs should be planned carefully so the base bundle does not become unnecessarily large.

### 5. Premium promise mismatch

If the store listing or paywall promises upcoming tracks without a concrete premium feature shipping now, refund risk and review risk go up.

## Suggested Next Execution Order

1. Finalize package name and account type.
2. Lock the Android v1 monetization model.
3. Implement Android production hardening.
4. Implement one premium unlock and billing flow.
5. Prepare privacy policy, Data safety, and store listing.
6. Run internal and closed testing.
7. Launch with staged rollout.

## Recommended Immediate Next Task for Me

If we continue from here, the highest-leverage next step is:

1. productionize Android identifiers and release signing setup, then
2. add the billing skeleton for a one-time premium unlock.

That path removes the biggest store blockers first and creates a concrete base for closed testing.
