import SwiftUI
import FirebaseCore
import DogTrackinCore

@main
struct DogTrackinApp: App {
    @State private var auth: AuthModel

    init() {
        let repository: any AuthRepository
        // GoogleService-Info.plist is per-environment and not committed. Without it,
        // FirebaseApp.configure() would crash, so fall back to a repository that
        // explains what's missing. See docs/ios-firebase-setup.md.
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            FirebaseApp.configure()
            repository = FirebaseAuthRepository()
        } else {
            repository = UnconfiguredAuthRepository()
        }
        _auth = State(initialValue: AuthModel(repository: repository))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(auth)
        }
    }
}
