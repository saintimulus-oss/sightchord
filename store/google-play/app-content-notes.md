# Google Play App Content Notes

Use this file as a working draft when completing the App content section in Play Console.

## Audience and positioning

- Product type: music education / harmony practice
- Core use case: chord study, improvisation, and harmonic vocabulary practice
- Current repository build: general audience educational tool

## Draft checklist

- Ads: none found in the current repository build
- User-generated content: none found in the current repository build
- Social or dating features: none
- News app behavior: none
- Gambling features: none
- Health features: none
- Government affiliation: none
- App access:
  - Core flows do not require sign-in.
  - Optional in-app email/password account creation now exists for account-linked premium sync.
  - Core flows are reachable immediately after cold start: Main Menu, Chordest practice generator, Chord Analyzer, and Settings.
  - Optional premium access is gated only by the Google Play managed one-time product `premium_unlock`.
  - Reviewers should use a dedicated pre-seeded premium account created through `tool/provision_reviewer_account.dart`.
  - Paste `store/google-play/reviewer-access.generated.txt` into Play Console after provisioning the reviewer account.

## Age and content rating preparation

- Capture screenshots that clearly show the practice and analyzer surfaces.
- Review all lesson text and catalog copy for age-sensitive content before submission.
- If the final launch keeps Chordest and Analyzer educational-only, the rating should likely remain low-risk, but complete the official questionnaire directly in the console.

## Declarations to revisit if product scope changes

- Billing or subscriptions
- Ads or promotional offers
- Community features
- AI-generated external content or chat features
