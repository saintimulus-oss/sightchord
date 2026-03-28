# Play Console Manual Tasks

Updated: 2026-03-28

## Scope

- This document is a working checklist for the manual steps that must still be
  completed directly in Google Play Console.
- Product and pricing direction should still be cross-checked with
  `docs/monetization_plan.md` and final release readiness notes.

## 1. Managed product setup

- Product type: managed one-time purchase
- Product ID: `premium_unlock`
- Public name recommendation: `Chordest Premium`
- Confirm the store copy matches the actual premium scope:
  - Included: Smart Generator, advanced harmony controls, premium Smart
    Generator controls
  - Not included unless shipped later: server-side sync beyond the current
    entitlement snapshot model, subscriptions, unrelated export bundles

## 2. Test accounts and release tracks

- Add Play license test accounts.
- Upload the current signed release `.aab` to `internal testing`.
- Validate purchase, cancel, pending, restore, refund, and reinstall behavior
  with test accounts.
- Move to `closed testing` only after the internal billing pass is clean.

## 3. Signing and upload

- Generate and store the real upload keystore securely.
- Finish Play App Signing enrollment.
- Wire release signing through `android/key.properties` or
  `ANDROID_KEYSTORE_*` environment variables.
- Keep keystore material out of version control.

## 4. Data safety, privacy, and app access

These answers must be entered directly in Play Console after checking the final
signed build.

- Data safety form
  - Local settings and study progress
  - Local premium entitlement cache
  - Optional custom metronome audio file copied into app-private storage
  - Optional email/password account auth via Firebase Authentication
  - Optional account-linked premium entitlement sync via Cloud Firestore
- Privacy policy URL
  - Confirm the published page matches the released build
- Data deletion URL
  - Confirm the public deletion instructions page is live at
    `https://saintimulus-oss.github.io/delete-account.html`
- App access
  - Run `dart run tool/provision_reviewer_account.dart` with the real Firebase
    project values and the dedicated reviewer email/password
  - Paste `store/google-play/reviewer-access.generated.txt` into
    `Policy and programs > App content > App access`
  - State clearly that core flows do not require sign-in
  - State clearly that optional account creation exists at
    `Main Menu > Settings > Account`
  - State clearly that premium review is done with the dedicated seeded
    reviewer account
  - State clearly that premium remains backed by the one-time managed product
    `premium_unlock`
- App content
  - Ads
  - Target audience
  - Sensitive content declarations
- Support and contact details

## 5. Store listing review

- Confirm the public app name is still `Chordest`.
- Confirm screenshots, descriptions, and feature graphic match the current UI.
- Describe Analyzer as an educational assistant, not as guaranteed theory truth.
- Confirm the free versus premium boundary matches the paywall copy.
- Remove placeholder text such as `beta`, `coming soon`, or `work in progress`.

## 6. Validation gates

### Internal testing

- No launch crash
- Main Menu, generator, analyzer, and settings open successfully
- Premium paywall opens successfully
- Restore CTA works
- Optional account screen opens and sign-in is possible when Firebase runtime
  configuration is present

### Closed testing

- Phone and tablet smoke pass
- Locale switching pass
- Offline behavior pass
- Background and resume pass
- Billing and restore pass

### Production-ready check

- Final screenshots uploaded
- Data safety, App content, and privacy sections completed
- Data deletion URL entered and verified
- `premium_unlock` is active in the production catalog
- Reviewer access notes pasted

## 7. Expected behavior when billing data is unavailable

- The app still launches normally.
- Free features remain usable.
- The paywall may show purchase actions as unavailable if catalog data cannot be
  loaded.
- Restore remains visible.

## 8. Billing behavior to verify manually

- Restore: startup sync, resume sync, and manual restore all converge on the
  same entitlement state
- Failure: free mode is not blocked and only the purchase message changes
- Pending: premium is not granted early and the pending message is shown
- Refund or ownership loss: a later owned-purchase sync should reflect the
  changed store state
- Account sync: when signed in, premium entitlement snapshot is copied to the
  same app account and can be rehydrated on another device after sign-in

## 9. Reference links

- One-time product lifecycle:
  <https://developer.android.com/google/play/billing/lifecycle/one-time>
- Upload Android App Bundle:
  <https://developer.android.com/studio/publish/upload-bundle>
- Developer requirements overview:
  <https://support.google.com/googleplay/android-developer/answer/9858738>
- Review timelines overview:
  <https://support.google.com/googleplay/android-developer/answer/9859751>
