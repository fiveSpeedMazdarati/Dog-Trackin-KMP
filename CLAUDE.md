# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Dog Trackin' is a **native Swift / SwiftUI** app for **iPhone, iPad and Apple TV only**. There is no Android
and no cross-platform/shared-code layer — do not add any. Minimum OS is **iOS / iPadOS / tvOS 18**.
Product intent and decisions live in `docs/product-spec.md`, `docs/implementation-plan.md` (ADRs, phases)
and `docs/open-questions.md`.

## Project generation (XcodeGen)

The Xcode project is **generated** from `project.yml` and is gitignored. Never hand-edit or commit
`DogTrackin.xcodeproj`; change `project.yml` and run `xcodegen generate`. New source files under `App/`
or `TV/` are picked up automatically on regeneration.

## Layout

- **`App/`** — `DogTrackin` iOS target (iPhone + iPad). `DogTrackinApp.swift` is the entry point; it
  configures Firebase only if `GoogleService-Info.plist` is present, otherwise injects
  `UnconfiguredAuthRepository`. Feature views live in `App/Sources/<Feature>/`. Firebase-backed repository
  implementations also live here (e.g. `FirebaseAuthRepository`).
- **`TV/`** — `DogTrackinTV` tvOS target. Read-only dashboard; intentionally has **no Firebase dependency**
  (it will use a paired-token HTTPS endpoint, ADR-5).
- **`Packages/DesignSystem`** — tokens (`Palette`, `DTColor`, `DTFont`, `DTSpacing`, `DTRadius`, `DTSize`),
  SF Symbol `Glyph`s, and components (`BannerView`, `SinceTile`, button styles). Token values mirror
  `docs/design-system/tokens.json`.
- **`Packages/DogTrackinCore`** — pure Swift domain + feature models (`User`, `AuthError`, `AuthRepository`
  protocol, `@Observable AuthModel`). **Must not import Firebase or UIKit.**

## Architecture conventions

- Swift 6 language mode with strict concurrency. UI models are `@MainActor @Observable` classes, injected
  with `.environment(_:)` and read with `@Environment(Type.self)`.
- Backends sit behind protocols in `DogTrackinCore`; Firebase implementations live in the app target;
  tests and previews use fakes (see `FakeAuthRepository` in `AuthModelTests`).
- Async APIs return `Result<_, TypedError>` across the repository boundary; never `await` a Firestore write's
  server acknowledgement in UI code (offline writes would hang — ADR-2).
- Dependencies via Swift Package Manager only, declared in `project.yml` (`packages:`) or a local
  `Package.swift`. Manual DI — no DI framework.

## Design system rules

- Use `DTColor` / `DTFont` / `DTSpacing` tokens, never raw colours or point sizes.
- **Lavender and sky are surfaces only; text and glyphs on them are always `DTColor.onAccent` (black).**
  `ContrastTests` enforces WCAG AA for every text/background pair.
- No red; destructive/critical uses the inverted ink/paper treatment. State is never colour-only.
- Glyphs are SF Symbols via `Glyph` (which attaches accessibility labels); no bitmap illustrations.
- System fonts via Apple text styles so Dynamic Type works.

## Common commands (macOS)

- Generate project: `xcodegen generate`
- Build iOS: `xcodebuild build -project DogTrackin.xcodeproj -scheme DogTrackin -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO`
- Build tvOS: same with `-scheme DogTrackinTV -destination 'generic/platform=tvOS Simulator'`
- Test a package: `cd Packages/DogTrackinCore && xcodebuild test -scheme DogTrackinCore -destination "id=$(../../scripts/pick-simulator.sh iOS)"`

Simulator launch + screenshots run only on demand via `.github/workflows/screenshots.yml` (PR label `screenshots`, or workflow_dispatch); `scripts/smoke-launch.sh` also prints base64 JPEG previews between `BEGIN-SCREENSHOT`/`END-SCREENSHOT` markers in the job log.

Tests use **Swift Testing** (`import Testing`, `@Test`, `#expect`).

## Firebase

Firebase (Auth now; Firestore, Cloud Functions, FCM, Crashlytics in later phases) via the
`firebase-ios-sdk` SPM package. `GoogleService-Info.plist` is not committed — see
`docs/ios-firebase-setup.md`. Sign in with Apple and Google currently return `.unavailable` (phase P1).
