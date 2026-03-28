# Account Sync Setup

This repository now includes optional email/password account auth plus account-aware premium sync.

## What the current implementation does

- Auth provider: Firebase Authentication (email/password)
- Account sync store: Cloud Firestore
- Premium behavior:
  - premium still works locally on the current device
  - when a user signs in, the app syncs premium entitlement state to that account
  - a later sign-in on another device can restore the synced entitlement snapshot

## Required Firebase console setup

1. Create a Firebase project for Chordest.
2. Enable Authentication -> Sign-in method -> Email/Password.
3. Create a Firestore database.
4. Add platform apps for Android, iOS, macOS, and Web as needed.

## Required runtime defines

Shared values:

- `FIREBASE_PROJECT_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_STORAGE_BUCKET`
- `FIREBASE_AUTH_DOMAIN` for web builds

Android:

- `FIREBASE_ANDROID_API_KEY`
- `FIREBASE_ANDROID_APP_ID`

iOS:

- `FIREBASE_IOS_API_KEY`
- `FIREBASE_IOS_APP_ID`
- `FIREBASE_IOS_BUNDLE_ID`

macOS:

- `FIREBASE_MACOS_API_KEY`
- `FIREBASE_MACOS_APP_ID`
- `FIREBASE_MACOS_BUNDLE_ID`

Web:

- `FIREBASE_WEB_API_KEY`
- `FIREBASE_WEB_APP_ID`
- `FIREBASE_WEB_MEASUREMENT_ID` optional

## Example local run

```bash
flutter run ^
  --dart-define=FIREBASE_PROJECT_ID=your-project-id ^
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=1234567890 ^
  --dart-define=FIREBASE_STORAGE_BUCKET=your-project.appspot.com ^
  --dart-define=FIREBASE_ANDROID_API_KEY=... ^
  --dart-define=FIREBASE_ANDROID_APP_ID=...
```

## Firestore document shape

- `users/{uid}/private/billing_state`
  - `version`
  - `lastSyncAt`
  - `records[]`

The payload mirrors the local billing snapshot structure.

## Recommended Firestore rules

Use per-user rules so one signed-in user cannot read or overwrite another
user's premium state.

```text
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/private/billing_state {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

The repository includes the same starter rule file at
`firebase/firestore.rules`.

## Google Play reviewer premium account

Because premium is now account-linked, Google Play reviewers need a dedicated
account that already has a seeded premium entitlement.

Provision that reviewer account with:

```bash
dart run tool/provision_reviewer_account.dart ^
  --web-api-key=YOUR_FIREBASE_WEB_API_KEY ^
  --project-id=YOUR_FIREBASE_PROJECT_ID ^
  --email=play-review@example.com ^
  --password=STRONG_REVIEW_PASSWORD
```

What the tool does:

- creates the Firebase Auth email/password account, or signs into it if it
  already exists
- writes an active `premium_unlock` entitlement snapshot to
  `users/{uid}/private/billing_state`
- generates a paste-ready Play Console note at
  `store/google-play/reviewer-access.generated.txt`

Recommended operating rules:

- keep the generated reviewer note out of source control
- reserve the seeded reviewer account for store review only
- use a separate throwaway account when manually testing in-app account
  deletion
- rerun the tool if you rotate the reviewer password or recreate the Firebase
  project

## Important production note

The current implementation syncs entitlement snapshots from the client after store verification on-device. This is enough to ship account-linked restore behavior quickly, but it is not the final security ceiling.

Before a wider commercial rollout, replace or supplement this with server-side purchase verification so premium ownership is not trusted purely from the client app state.
