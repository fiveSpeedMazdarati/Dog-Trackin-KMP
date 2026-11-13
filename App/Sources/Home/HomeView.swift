import SwiftUI
import DesignSystem
import DogTrackinCore

/// Placeholder signed-in screen until the Animals feature lands (phase P1).
struct HomeView: View {
    @Environment(AuthModel.self) private var auth
    let user: DogTrackinCore.User

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DTSpacing.l) {
                    Text("Signed in as \(user.displayName ?? user.email)")
                        .font(DTFont.subheadline)
                        .foregroundStyle(DTColor.textSecondary)

                    BannerView(kind: .info, title: "Coming soon", message: "Add your dogs and start logging in the next build.")
                        .clipShape(RoundedRectangle(cornerRadius: DTRadius.medium, style: .continuous))

                    // Sample tiles showing the design system; replaced by real data in P1.
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: DTSpacing.m)], spacing: DTSpacing.m) {
                        SinceTile(glyph: .pee, elapsed: "—", detail: "Pee")
                        SinceTile(glyph: .meal, elapsed: "—", detail: "Meal")
                        SinceTile(glyph: .medication, elapsed: "—", detail: "Medication")
                        SinceTile(glyph: .walk, elapsed: "—", detail: "Walk")
                    }
                }
                .padding(DTSpacing.l)
            }
            .background(DTColor.background)
            .navigationTitle("Dog Trackin'")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sign out") { auth.signOut() }
                        .foregroundStyle(DTColor.onBackground)
                }
            }
        }
    }
}

#Preview {
    HomeView(user: .init(id: "1", email: "pat@example.com", displayName: "Pat"))
        .environment(AuthModel(repository: UnconfiguredAuthRepository()))
}
