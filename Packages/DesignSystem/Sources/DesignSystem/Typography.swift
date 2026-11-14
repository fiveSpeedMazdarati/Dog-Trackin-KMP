import SwiftUI

/// Type scale built on Apple text styles so Dynamic Type works automatically (design-system.md §2).
/// System font only — no bundled fonts.
public enum DTFont {
    public static let display = Font.system(.largeTitle, weight: .bold)
    public static let title1 = Font.system(.title, weight: .bold)
    public static let title2 = Font.system(.title2, weight: .semibold)
    public static let title3 = Font.system(.title3, weight: .semibold)
    public static let headline = Font.headline
    public static let body = Font.body
    public static let callout = Font.callout
    public static let subheadline = Font.subheadline
    public static let footnote = Font.footnote
    public static let caption = Font.system(.caption, weight: .medium)

    /// Large "time since" numbers: rounded design, monospaced digits so they don't jitter.
    /// (Rounded vs default is an open design question.)
    public static let sinceNumber = Font.system(.largeTitle, design: .rounded, weight: .bold).monospacedDigit()
}
