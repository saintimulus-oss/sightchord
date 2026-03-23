# App Store App Privacy Notes

Use this file as a draft for App Store Connect "App Privacy" answers for the current repository build.

## Important

- This is a technical draft from the repository state, not a legal guarantee.
- Re-check the final archive in Xcode before submission.
- Revisit this file if analytics, crash reporting, billing, login, sync, or remote APIs are added.

## Current Repository Snapshot

- No user account creation flow found
- No ad SDKs found
- No analytics SDKs found
- No crash-reporting SDKs found
- No camera, microphone, location, contacts, or photo-library usage strings found in `Info.plist`
- Settings and progress appear to stay on device

## Draft App Privacy Direction

### Data Used to Track You

Current repo-based draft: `No`

### Data Linked to You

Current repo-based draft: likely `No`

### Data Not Linked to You

Current repo-based draft: likely `No`

Reasoning:

- The current repository build does not appear to send user data to a backend or third-party analytics service.
- Local settings persistence alone does not automatically imply App Store privacy disclosures as collected app data, but the final archived build must be checked against all linked SDKs.

## Privacy Manifest Reminder

The iOS project currently includes `Runner/PrivacyInfo.xcprivacy` with a `UserDefaults` required-reason declaration because the app stores local settings and progress. Confirm that the final archive does not require additional required-reason API entries.
