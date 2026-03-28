# App Store App Privacy Notes

Use this file as a draft for App Store Connect "App Privacy" answers for the
current repository build.

## Important

- This is a technical draft from the repository state, not a legal guarantee.
- The repository already includes a one-time premium unlock flow plus optional
  account auth and entitlement sync, so re-check the final archive in Xcode,
  linked SDKs, and App Store Connect answers before submission.
- Revisit this file if analytics, crash reporting, server-side purchase
  verification, additional sync, or remote APIs are added.

## Current Repository Snapshot

- Optional email/password account creation and sign-in via Firebase
  Authentication
- Optional account-linked premium entitlement sync via Cloud Firestore
- No ad SDKs found
- No analytics SDKs found
- No crash-reporting SDKs found
- No camera, microphone, location, contacts, or photo-library usage strings
  found in `Info.plist`
- Settings, study progress, and premium entitlement cache are still stored
  locally on device
- Users can optionally import a metronome audio file that is copied into
  app-private storage on device
- The app includes a one-time premium purchase flow and purchase restore
  handling through store APIs on supported store platforms

## Draft App Privacy Direction

### Data Used to Track You

Current repo-based draft: `No`

### Data Linked to You

Current repo-based draft: likely `Yes`

Likely categories to review manually in App Store Connect:

- Contact Info -> Email Address
- Identifiers -> User ID
- Potential purchase-related entitlement state if Apple review interprets synced
  premium ownership as purchase information

Likely purposes:

- App functionality
- Account management

### Data Not Linked to You

Current repo-based draft: likely `No` for developer-operated backend collection
in the current repository build

Reasoning:

- Core practice data still remains local-first on the device.
- Optional account auth now introduces developer-operated identity handling
  through Firebase Authentication.
- Optional premium sync now introduces developer-operated account-linked data
  through Cloud Firestore.
- Final App Store Connect answers still need to be checked against the exact
  archived build, final Firebase setup, and Apple's category definitions.

## Operational follow-up

- The app now includes a dedicated in-app account deletion flow.
- Keep the public deletion instructions page and the privacy policy aligned with
  the released build.

## Privacy Manifest Reminder

The iOS project currently includes `Runner/PrivacyInfo.xcprivacy` with a
`UserDefaults` required-reason declaration because the app stores local
settings, progress, and entitlement cache. Confirm that the final archive does
not require additional required-reason API entries.
