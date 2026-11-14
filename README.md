# Dog Trackin'

A shared care log for your dog. Whenever anyone feeds, walks, lets out or medicates the dog,
everyone else caring for that dog is notified. Native **Swift / SwiftUI** for iPhone, iPad and Apple TV.

- Product spec: [docs/product-spec.md](docs/product-spec.md)
- Implementation plan: [docs/implementation-plan.md](docs/implementation-plan.md)
- Design system: [docs/design-system/design-system.md](docs/design-system/design-system.md)
- Open questions: [docs/open-questions.md](docs/open-questions.md)

## Requirements

- macOS with **Xcode 16 or later** (iOS/tvOS 18 SDK, Swift 6)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`

## Getting started

```sh
xcodegen generate          # creates DogTrackin.xcodeproj from project.yml
open DogTrackin.xcodeproj
```

The `.xcodeproj` is generated and gitignored. Edit `project.yml`, not the project, and re-run
`xcodegen generate` after pulling changes or adding/removing files.

Optional local setup:
- **Signing:** create `Configs/Local.xcconfig` containing `DEVELOPMENT_TEAM = <your Team ID>`.
- **Firebase:** add `App/Resources/GoogleService-Info.plist`; see [docs/ios-firebase-setup.md](docs/ios-firebase-setup.md).
  Without it the app still builds and runs, but sign-in reports that Firebase isn't configured.

## Layout

| Path | What |
|---|---|
| `project.yml` | XcodeGen spec: targets `DogTrackin` (iPhone + iPad) and `DogTrackinTV` (tvOS) |
| `App/` | iOS app target: entry point, feature views, Firebase-backed repositories |
| `TV/` | tvOS dashboard target (no Firebase dependency) |
| `Packages/DesignSystem` | Colour tokens, type scale, SF Symbol glyphs, components, contrast tests |
| `Packages/DogTrackinCore` | Pure-Swift domain and feature models (no Firebase/UIKit), with tests |
| `Configs/` | Shared `.xcconfig`; personal `Local.xcconfig` is gitignored |
| `scripts/` | CI helpers |

## Tests

Package tests run on a simulator:

```sh
cd Packages/DogTrackinCore
xcodebuild test -scheme DogTrackinCore -destination 'platform=iOS Simulator,name=<any installed iPhone>'
```

Or open the package (or the generated project) in Xcode and press ⌘U.

## Screenshots (on demand)

CI does not launch the app on every push. To get light/dark screenshots on iPhone and iPad
(and a crash-on-launch check), add the **`screenshots`** label to a pull request (remove and re-add
it to run again), or use **Actions → Screenshots → Run workflow**. The images are attached to the
run as the `screenshots` artifact.
