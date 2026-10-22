# iOS Firebase setup

The shared Kotlin code uses the `dev.gitlive:firebase-*` wrappers, which on iOS
call into the **native Firebase iOS SDK**. Two steps have to be done inside the
Xcode project (`iosApp/`) because they touch the Xcode project file and Firebase
config — they can't be committed from the shared Gradle build.

The Swift entry point (`iosApp/iosApp/iOSApp.swift`) already calls
`FirebaseApp.configure()`, so once the two steps below are done, Firebase is
initialized on launch.

## 1. Add the Firebase iOS SDK (Swift Package Manager)

1. Open `iosApp/iosApp.xcodeproj` in Xcode.
2. **File → Add Package Dependencies…**
3. Enter the package URL: `https://github.com/firebase/firebase-ios-sdk`
4. Pick a recent version (Up to Next Major).
5. Add these products to the **iosApp** target — matching the wrappers used in
   `composeApp` (`firebase-auth`, `firebase-firestore`, `firebase-crashlytics`,
   plus analytics):
   - `FirebaseAuth`
   - `FirebaseFirestore`
   - `FirebaseCrashlytics`
   - `FirebaseAnalytics`

## 2. Add `GoogleService-Info.plist`

1. In the [Firebase console](https://console.firebase.google.com/), open the iOS
   app whose bundle id is `com.softwareofnote.dogtrackin` (create the iOS app if
   it doesn't exist yet).
2. Download `GoogleService-Info.plist`.
3. Drag it into the `iosApp/iosApp/` group in Xcode, ticking **Copy items if
   needed** and the **iosApp** target.

> The file is gitignored (see `.gitignore`) and must not be committed — it's
> per-environment config. Each developer/CI environment supplies its own.

## Verifying

- The Gradle side (shared framework) builds without any of the above — CI's
  `Build iOS framework` job runs `./gradlew :composeApp:linkDebugFrameworkIosSimulatorArm64`.
- The full app only links once the SPM package above is added, and Firebase only
  works at runtime once `GoogleService-Info.plist` is present.
