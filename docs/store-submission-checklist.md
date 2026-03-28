# Chordest Store Submission Checklist

This checklist is the final manual pass before pressing submit in Google Play Console or App Store Connect.

## Common

- Confirm the public app name is still `Chordest`.
- Confirm the package/bundle ID `io.github.saintimulusoss.chordest` is final.
- Confirm the release version and build number are final.
- Confirm the support URL is `https://saintimulus-oss.github.io/support.html`.
- Confirm the privacy policy URL is `https://saintimulus-oss.github.io/privacy-policy.html`.
- Confirm the terms URL is `https://saintimulus-oss.github.io/terms.html`.
- Confirm screenshots match the final UI and locale mix used in the store listing.
- Confirm no placeholder text remains in release notes, review notes, or support copy.

## Google Play Console

- Create the app record.
- Choose app type and category.
- Upload the signed `.aab`.
- Enroll in Play App Signing.
- Complete App content declarations.
- Provision the dedicated reviewer premium account with
  `dart run tool/provision_reviewer_account.dart`.
- Fill `App access` using `store/google-play/reviewer-access.generated.txt`.
- Complete the Data safety form.
- Add the data deletion URL `https://saintimulus-oss.github.io/delete-account.html` if Play Console requests it.
- Complete content rating.
- Add the support URL and privacy policy URL.
- Add the short description and full description from the `store/` folder.
- Upload launcher icon, feature graphic, phone screenshots, and any tablet screenshots you plan to support.
- Run an internal test release.
- Review pre-launch report output before production rollout.

## App Store Connect

- Create the app record for iOS.
- Confirm the final bundle identifier matches the Xcode target.
- Upload the archive from Xcode Organizer or Transporter.
- Confirm the archived app includes a valid `PrivacyInfo.xcprivacy` with the final set of required-reason APIs.
- Fill in App Privacy.
- Fill in age rating.
- Add support URL and privacy policy URL.
- Add subtitle, keywords, description, promotional text, and review notes from the `store/` folder.
- Upload iPhone screenshots and any iPad screenshots if you want iPad distribution.
- Add TestFlight internal testers and validate a release build on real hardware.
- Add final review notes that explain the app is local-first, that core flows do not require an account, and that optional email/password sign-in exists for account-linked premium sync.

## Real-Device Validation

- Android phone: launch, audio playback, metronome, analyzer, and settings persistence.
- Android tablet: layout fit, touch targets, and orientation behavior.
- iPhone: launch, audio playback, analyzer flow, settings persistence, and localization.
- iPad: layout fit and orientation behavior if iPad distribution remains enabled.

## Go / No-Go

- No crash-on-launch reports in internal testing.
- No missing assets or silent audio regressions.
- No untranslated high-visibility strings in the target launch locales.
- No placeholder support or legal URLs in the console metadata.
