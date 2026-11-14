import SwiftUI

// MARK: - Buttons

/// Lavender fill, black label. The app's primary call to action.
public struct PrimaryButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DTFont.headline)
            .foregroundStyle(DTColor.onAccent)
            .frame(maxWidth: .infinity, minHeight: DTSize.buttonHeight)
            .background(DTColor.accentPrimary, in: RoundedRectangle(cornerRadius: DTRadius.medium, style: .continuous))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

/// Outline in the foreground colour, transparent fill.
public struct SecondaryButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DTFont.headline)
            .foregroundStyle(DTColor.onBackground)
            .frame(maxWidth: .infinity, minHeight: DTSize.buttonHeight)
            .overlay(
                RoundedRectangle(cornerRadius: DTRadius.medium, style: .continuous)
                    .strokeBorder(DTColor.onBackground, lineWidth: 1.5)
            )
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

/// Inverted fill — no red anywhere. Always pair with a confirmation step.
public struct DestructiveButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DTFont.headline)
            .foregroundStyle(DTColor.criticalForeground)
            .frame(maxWidth: .infinity, minHeight: DTSize.buttonHeight)
            .background(DTColor.criticalBackground, in: RoundedRectangle(cornerRadius: DTRadius.medium, style: .continuous))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

// MARK: - Banner

/// Banner severities in display-priority order (spec FR-G1). State is always glyph + word + surface.
public enum BannerKind: Int, Comparable, Sendable {
    case critical = 0, offline, warning, info

    public static func < (lhs: BannerKind, rhs: BannerKind) -> Bool { lhs.rawValue < rhs.rawValue }

    var glyph: Glyph {
        switch self {
        case .critical: .critical
        case .offline: .offline
        case .warning: .warning
        case .info: .info
        }
    }
}

/// Full-width banner shown under the navigation bar; pushes content down rather than overlaying it.
public struct BannerView: View {
    let kind: BannerKind
    let title: String
    let message: String?
    let onDismiss: (() -> Void)?

    public init(kind: BannerKind, title: String, message: String? = nil, onDismiss: (() -> Void)? = nil) {
        self.kind = kind
        self.title = title
        self.message = message
        self.onDismiss = onDismiss
    }

    private var background: Color {
        switch kind {
        case .critical, .offline: DTColor.criticalBackground
        case .warning: DTColor.accentPrimary
        case .info: DTColor.accentInfo
        }
    }

    private var foreground: Color {
        switch kind {
        case .critical, .offline: DTColor.criticalForeground
        case .warning, .info: DTColor.onAccent
        }
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: DTSpacing.m) {
            kind.glyph.image.font(DTFont.headline)
            VStack(alignment: .leading, spacing: DTSpacing.xxs) {
                Text(title).font(DTFont.headline)
                if let message { Text(message).font(DTFont.callout) }
            }
            Spacer(minLength: 0)
            if let onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .frame(minWidth: DTSize.minTouchTarget, minHeight: DTSize.minTouchTarget)
                }
                .accessibilityLabel(Text("Dismiss"))
            }
        }
        .foregroundStyle(foreground)
        .padding(.horizontal, DTSpacing.l)
        .padding(.vertical, DTSpacing.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Since tile

/// "2 h 14 m · Meal · by Sam" — the glanceable unit used on the dog header, iPad counter mode and TV.
public struct SinceTile: View {
    let glyph: Glyph
    let elapsed: String
    let detail: String

    public init(glyph: Glyph, elapsed: String, detail: String) {
        self.glyph = glyph
        self.elapsed = elapsed
        self.detail = detail
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DTSpacing.xs) {
            glyph.image
                .font(DTFont.title3)
                .foregroundStyle(DTColor.onAccent)
                .frame(width: DTSize.minTouchTarget, height: DTSize.minTouchTarget)
                .background(DTColor.accentInfo, in: Circle())
            Text(elapsed).font(DTFont.sinceNumber).foregroundStyle(DTColor.onBackground)
            Text(detail).font(DTFont.subheadline).foregroundStyle(DTColor.textSecondary)
        }
        .padding(DTSpacing.l)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DTColor.surface, in: RoundedRectangle(cornerRadius: DTRadius.large, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DTRadius.large, style: .continuous)
                .strokeBorder(DTColor.divider, lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }
}

#Preview("Components") {
    ScrollView {
        VStack(spacing: DTSpacing.l) {
            BannerView(kind: .critical, title: "Service issue", message: "Sync is delayed. Your changes are saved.")
            BannerView(kind: .offline, title: "Offline", message: "3 changes will sync")
            BannerView(kind: .warning, title: "Heads up", message: "Scheduled maintenance tonight", onDismiss: {})
            BannerView(kind: .info, title: "New", message: "You can now log walks", onDismiss: {})
            Group {
                SinceTile(glyph: .meal, elapsed: "2h 14m", detail: "Meal · by Sam")
                Button("Log meal") {}.buttonStyle(PrimaryButtonStyle())
                Button("Edit") {}.buttonStyle(SecondaryButtonStyle())
                Button("Delete Biscuit") {}.buttonStyle(DestructiveButtonStyle())
            }
            .padding(.horizontal, DTSpacing.l)
        }
    }
    .background(DTColor.background)
}
