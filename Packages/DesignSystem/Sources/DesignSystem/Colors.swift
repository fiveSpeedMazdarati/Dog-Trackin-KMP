import SwiftUI
import UIKit

extension Color {
    init(rgb: UInt32) {
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0
        )
    }

    /// A colour that resolves per light/dark appearance.
    static func adaptive(light: UInt32, dark: UInt32) -> Color {
        Color(uiColor: UIColor { traits in
            let rgb = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
                green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
                blue: CGFloat(rgb & 0xFF) / 255.0,
                alpha: 1
            )
        })
    }
}

/// Semantic colour tokens (design-system.md §1.3). Use these, never raw hex, in views.
public enum DTColor {
    public static let background = Color.adaptive(light: Palette.paper, dark: Palette.ink)
    public static let surface = Color.adaptive(light: Palette.paper, dark: Palette.gray900)
    public static let onBackground = Color.adaptive(light: Palette.ink, dark: Palette.paper)
    public static let textSecondary = Color.adaptive(light: Palette.gray600, dark: Palette.gray400)
    public static let divider = Color.adaptive(light: Palette.gray300, dark: Palette.gray800)

    /// Light purple fill. Text/glyphs on it: `onAccent`.
    public static let accentPrimary = Color(rgb: Palette.lavender)
    public static let accentPrimarySoft = Color.adaptive(light: Palette.lavenderSoft, dark: Palette.lavenderSoftDark)

    /// Light blue fill. Text/glyphs on it: `onAccent`.
    public static let accentInfo = Color(rgb: Palette.sky)
    public static let accentInfoSoft = Color.adaptive(light: Palette.skySoft, dark: Palette.skySoftDark)

    /// Always black — the only legal content colour on lavender/sky, in both appearances.
    public static let onAccent = Color(rgb: Palette.ink)

    /// Critical banners/destructive actions invert against the page.
    public static let criticalBackground = Color.adaptive(light: Palette.ink, dark: Palette.paper)
    public static let criticalForeground = Color.adaptive(light: Palette.paper, dark: Palette.ink)
    public static let focusRing = Color.adaptive(light: Palette.ink, dark: Palette.paper)
}
