# Google Play Data Safety Notes

Use this as a starting point when filling in the Google Play Data safety form for the current repository build.

## Important

- This is a repository-based draft, not a legal certification.
- Because the repository now includes a one-time premium unlock flow, re-check the final signed `.aab`, Play Console answers, and every included SDK before submission.
- Because the repository now includes optional account auth and account-linked premium sync, re-check the final signed `.aab`, Play Console answers, and every included SDK before submission.

## Current Repository Snapshot

- Optional email/password account sign-in via Firebase Authentication
- Account-linked premium entitlement sync via Cloud Firestore
- No in-app ads or ad SDKs found in the current repository build
- No analytics or crash-reporting SDKs found in the current repository build
- No camera, microphone, location, contacts, or photo-library permissions declared in the Android manifest
- Practice settings, study progress, and premium entitlement state are stored locally on device through shared preferences
- Users can optionally import a metronome audio file; the app copies the selected file into app-private storage on device
- The app includes Google Play Billing flow for a one-time premium unlock and can query product details, purchases, and restore state through store APIs

## Draft Answering Notes

### Does the app collect or share any required user data types?

Current repo-based draft for developer-operated collection or sharing: likely `Yes`, because optional account sign-in now processes email address and user ID through Firebase Authentication and premium sync stores entitlement state in Firestore

Reasoning:

- The current app is still mostly local-first for practice features.
- Settings, progress, custom metronome files, and premium entitlement cache are stored on-device.
- Optional account auth now introduces developer-operated account data handling through Firebase services.
- The final Play Console answers should be checked against the exact submitted build and Firebase configuration.

### Is all data processed ephemerally?

Current repo-based draft: likely `No`

Reasoning:

- The app keeps settings, progress, copied custom audio files, and premium entitlement cache on-device between sessions.
- Even if no data leaves the device, local persistence is not ephemeral processing.

### Can users request that data is deleted?

Current repo-based draft: likely `Yes`

Reasoning:

- The app now includes an in-app account deletion entry point at `Main Menu > Settings > Account`.
- The public website can expose an outside-app deletion instruction page at `delete-account.html` for Play Console data deletion review.
- Local settings, progress, copied custom audio files, and cached entitlement state can still be removed by clearing app data or uninstalling the app.
- Purchase history managed by Google Play is subject to the user's store account and Google's own controls and policies.

### Security practices

Before submitting, verify the current Play Console options around:

- Data encrypted in transit
- Data deletion
- Independent security review
- Any billing-specific disclosures required for the submitted premium unlock configuration

Only answer `Yes` where the final app and infrastructure clearly support it.
