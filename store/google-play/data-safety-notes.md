# Google Play Data Safety Notes

Use this as a starting point when filling in the Google Play Data safety form for the current repository build.

## Important

- This is a repository-based draft, not a legal certification.
- Re-check the final signed `.aab` and every included SDK before submission.
- If analytics, crash reporting, billing, cloud sync, ads, or account systems are added later, this draft must be updated.

## Current Repository Snapshot

- No account sign-in flow in the current repository build
- No in-app ads or ad SDKs found in the current repository build
- No analytics or crash-reporting SDKs found in the current repository build
- No camera, microphone, location, contacts, or photo-library permissions declared in the Android manifest
- Practice settings and progress are stored locally on device through shared preferences

## Draft Answering Notes

### Does the app collect or share any required user data types?

Current repo-based draft: `No`

Reasoning:

- The current app appears local-first.
- Settings and progress are stored on-device.
- No backend, auth, analytics, or ad flows were identified in the repository scan.

### Is all data processed ephemerally?

Current repo-based draft: likely `No`

Reasoning:

- The app keeps settings and progress on-device between sessions.
- Even if no data leaves the device, local persistence is not ephemeral processing.

### Can users request that data is deleted?

Current repo-based draft: `No in-app deletion request flow`

Reasoning:

- There is no account-linked server data in the current repository build.
- Local data can be removed by clearing app data or uninstalling the app.

### Security practices

Before submitting, verify the current Play Console options around:

- Data encrypted in transit
- Data deletion
- Independent security review

Only answer `Yes` where the final app and infrastructure clearly support it.
