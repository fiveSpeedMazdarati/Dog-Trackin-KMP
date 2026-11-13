# Firebase setup (iOS)

The Firebase iOS SDK is already declared as a Swift package in `project.yml`
(`https://github.com/firebase/firebase-ios-sdk`, from 12.0.0; the `DogTrackin` target links `FirebaseAuth`).
`xcodegen generate` adds it to the project automatically, and Xcode resolves it on first open.

What you supply per machine or environment is the **config file**:

1. In the [Firebase console](https://console.firebase.google.com/), open (or create) the iOS app with bundle ID
   **`com.softwareofnote.dogtrackin`**.
   - Note: the old KMP iOS shell used `com.softwareofnote.dogtrackin.DogTrackin<TEAM_ID>`. If your Firebase iOS
     app was registered under that ID, register a new iOS app with the ID above.
2. Download `GoogleService-Info.plist` and save it as **`App/Resources/GoogleService-Info.plist`**.
3. Run `xcodegen generate` again so the file is added to the target's resources.

The file is gitignored and must never be committed.

## Behaviour without the file

`DogTrackinApp` checks for the plist at launch. If it's missing, Firebase is **not** configured (calling
`FirebaseApp.configure()` without it would crash) and the app uses `UnconfiguredAuthRepository`, so sign-in
shows "Firebase isn't configured in this build." This is what CI builds.

## Environments (planned, P0)

Use separate Firebase projects for **dev** and **prod**. The plan is one plist per configuration, selected at
build time. The mechanism will be decided when the second project exists.

## Later phases
- **Sign in with Apple** (P1): enable the capability (needs a Team ID in `Configs/Local.xcconfig`) and the Apple
  provider in Firebase Auth.
- **Google** (P1): add the `GoogleSignIn-iOS` package and the reversed client ID URL scheme.
- **Push** (P2): upload an APNs auth key (.p8) to Firebase Cloud Messaging; add the Push Notifications capability.
