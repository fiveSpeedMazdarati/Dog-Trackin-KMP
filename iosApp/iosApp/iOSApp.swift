import SwiftUI
import FirebaseCore

@main
struct iOSApp: App {
    // Firebase must be configured before any shared Kotlin code touches
    // Firebase.auth; the gitlive KMP wrappers rely on the native iOS SDK
    // having been initialized here.
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}