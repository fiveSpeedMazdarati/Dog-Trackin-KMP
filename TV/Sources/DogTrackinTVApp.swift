import SwiftUI
import DesignSystem

/// Apple TV dashboard. Read-only; pairing and live data arrive in phase P4
/// (docs/implementation-plan.md, ADR-5). Deliberately has no Firebase dependency.
@main
struct DogTrackinTVApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
    }
}

struct DashboardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: DTSpacing.xxl) {
            HStack(spacing: DTSpacing.l) {
                Glyph.animal.image
                    .font(DTFont.display)
                    .foregroundStyle(DTColor.onAccent)
                    .frame(width: 96, height: 96)
                    .background(DTColor.accentPrimary, in: Circle())
                Text("Dog Trackin'").font(DTFont.display).foregroundStyle(DTColor.onBackground)
            }
            HStack(spacing: DTSpacing.xl) {
                SinceTile(glyph: .pee, elapsed: "—", detail: "Out")
                SinceTile(glyph: .meal, elapsed: "—", detail: "Meal")
                SinceTile(glyph: .medication, elapsed: "—", detail: "Medication")
                SinceTile(glyph: .walk, elapsed: "—", detail: "Walk")
            }
            Text("Pair this Apple TV from the Dog Trackin' app on your iPhone. (Coming soon.)")
                .font(DTFont.title3)
                .foregroundStyle(DTColor.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(DTColor.background)
    }
}

#Preview {
    DashboardView()
}
