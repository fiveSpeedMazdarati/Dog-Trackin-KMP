# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DogTrackin is a Kotlin Multiplatform (KMP) app targeting **Android** and **iOS**, with a shared Compose Multiplatform UI. All UI and business logic live in the shared `commonMain` source set; platform folders exist only for entry points and `expect`/`actual` implementations.

## Module Structure

The project is split into two Gradle modules:

- **`:composeApp`** — KMP library (`com.android.kotlin.multiplatform.library` + `kotlinMultiplatform`). Contains all shared code: `commonMain`, `androidMain` (platform actuals + Android-specific deps), `iosMain`, and `commonTest`. Produces the iOS static framework (`ComposeApp`).
- **`:androidApp`** — Thin Android application (`com.android.application`). Contains only `MainActivity`, the `AndroidManifest.xml`, Android resources, and the Firebase `google-services`/`crashlytics` Gradle plugins. Depends on `:composeApp`.

This split is required by AGP 9.0+, which no longer allows `com.android.application` and `kotlinMultiplatform` in the same module.

## Common Commands

Requires **JDK 17** (the toolchain configured in `composeApp/build.gradle.kts`; AGP 9 / Gradle 9 require JDK 17+). Use `./gradlew` on macOS/Linux, `.\gradlew.bat` on Windows.

- **Build Android debug APK**: `./gradlew :androidApp:assembleDebug`
- **Run all common tests on every target**: `./gradlew :composeApp:allTests`
- **Run JVM/Android unit tests**: `./gradlew :composeApp:testAndroidHostTest`
- **Run a single test class**: `./gradlew :composeApp:testAndroidHostTest --tests "com.softwareofnote.dogtrackin.AuthViewModelTest"`
- **iOS**: the iOS framework (`ComposeApp`, static) is produced by the Gradle build; build/run the `iosApp` Xcode project in `iosApp/` (or via the IDE's iosApp run configuration), which triggers the Gradle framework build automatically.

## Architecture

The codebase follows a **Clean Architecture** layering within feature packages under `composeApp/src/commonMain/kotlin/com/softwareofnote/dogtrackin/`. The `auth` feature is the reference example, split into three layers:

- **`domain/`** — pure Kotlin: the `AuthRepository` interface, `User` model, and the `AuthResult` sealed class. No framework dependencies; this is what the rest of the code programs against.
- **`data/`** — `FirebaseAuthRepository` implements `AuthRepository` against the Firebase backend.
- **`presentation/`** — `AuthViewModel` (extends `androidx.lifecycle.ViewModel`, shared via KMP lifecycle libraries) plus Compose screens. UI state is exposed as a `StateFlow<AuthUiState>` (an `Idle`/`Loading`/`Success`/`Error` sealed class) and `StateFlow<User?>`.

New features should mirror this `domain` / `data` / `presentation` package split.

**App composition**: `App.kt` is the shared Compose root. It constructs `FirebaseAuthRepository`, wraps it in an `AuthViewModel`, and switches between `LoginScreen` and the authed content based on `currentUser`. Dependencies are wired manually here (`remember { FirebaseAuthRepository() }`) — there is no DI framework.

**Platform entry points**: Android `MainActivity` (in `:androidApp`) and iOS `MainViewController()` (in `composeApp/src/iosMain/`) both simply call the shared `App()`. Platform-specific behavior uses the `expect`/`actual` pattern — see `Platform.kt` (expect) with `Platform.android.kt` / `Platform.ios.kt` (actual).

## Firebase

Firebase (Auth, Firestore, Crashlytics, Analytics) is the backend. Note the **dual dependency setup** in `composeApp/build.gradle.kts`:

- `commonMain` uses the **`dev.gitlive:firebase-*`** KMP wrappers — this is the API the shared code calls (e.g. `Firebase.auth`).
- `composeApp`'s `androidMain` additionally pulls the **native Google `firebase-bom`** SDKs.
- `:androidApp` applies the `google-services` and `firebase-crashlytics` Gradle plugins (which process `google-services.json`).

Firebase config files (`google-services.json`, `GoogleService-Info.plist`) are not committed. `loginWithGoogle()` and `loginWithApple()` are currently stubbed and return an error. Wiring Firebase into the iOS app (SPM package + `GoogleService-Info.plist`) is documented in [docs/ios-firebase-setup.md](docs/ios-firebase-setup.md).

## Conventions

- Declare all dependencies via the version catalog `gradle/libs.versions.toml` (referenced as `libs.*`), not hardcoded coordinates where a catalog entry exists.
- Keep logic in `commonMain`; only drop into `androidMain`/`iosMain` when a platform API is strictly required.
- Tests live in `commonTest` using `kotlin.test` annotations. Follow `AuthViewModelTest` for the pattern: inject a fake repository (e.g. `FakeAuthRepository`) and drive coroutines with `runTest` + `advanceUntilIdle()`.
