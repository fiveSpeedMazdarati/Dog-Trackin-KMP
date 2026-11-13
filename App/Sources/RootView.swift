import SwiftUI
import DesignSystem
import DogTrackinCore

/// Switches between sign-in and the signed-in app based on the current user.
struct RootView: View {
    @Environment(AuthModel.self) private var auth

    var body: some View {
        Group {
            if let user = auth.currentUser {
                HomeView(user: user)
            } else {
                LoginView()
            }
        }
        .background(DTColor.background)
    }
}

#Preview {
    RootView()
        .environment(AuthModel(repository: UnconfiguredAuthRepository()))
}
