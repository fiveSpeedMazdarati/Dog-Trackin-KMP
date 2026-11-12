import Foundation

/// Primitive colour palette as 0xRRGGBB values. Mirrors `docs/design-system/tokens.json`.
///
/// Rule: `lavender` and `sky` are **surfaces, never text** — text on them is always `ink`.
/// Kept free of SwiftUI so contrast can be unit-tested (`ContrastTests`).
public enum Palette {
    public static let ink: UInt32 = 0x000000
    public static let paper: UInt32 = 0xFFFFFF

    /// Light purple — primary actions, people, selection.
    public static let lavender: UInt32 = 0xD8CCFF
    public static let lavenderSoft: UInt32 = 0xEFEAFF
    /// `lavender` at 16% over `ink` (dark-mode soft surface).
    public static let lavenderSoftDark: UInt32 = 0x232129

    /// Light blue — events/activity, information, sync, location.
    public static let sky: UInt32 = 0xC6E4FF
    public static let skySoft: UInt32 = 0xEAF5FF
    /// `sky` at 16% over `ink` (dark-mode soft surface).
    public static let skySoftDark: UInt32 = 0x202429

    public static let gray900: UInt32 = 0x1A1A1A
    public static let gray800: UInt32 = 0x2A2A2A
    public static let gray600: UInt32 = 0x5C5C5C
    public static let gray400: UInt32 = 0xA3A3A3
    public static let gray300: UInt32 = 0xC7C7C7
}

/// WCAG 2.x colour math.
public enum ColorMath {
    public static func relativeLuminance(_ rgb: UInt32) -> Double {
        func channel(_ shift: UInt32) -> Double {
            let c = Double((rgb >> shift) & 0xFF) / 255.0
            return c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * channel(16) + 0.7152 * channel(8) + 0.0722 * channel(0)
    }

    public static func contrastRatio(_ a: UInt32, _ b: UInt32) -> Double {
        let la = relativeLuminance(a), lb = relativeLuminance(b)
        return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)
    }
}
