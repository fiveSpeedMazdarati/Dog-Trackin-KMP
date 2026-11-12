import CoreGraphics

/// 4-pt spacing scale (design-system.md §4).
public enum DTSpacing {
    public static let xxs: CGFloat = 2
    public static let xs: CGFloat = 4
    public static let s: CGFloat = 8
    public static let m: CGFloat = 12
    public static let l: CGFloat = 16
    public static let xl: CGFloat = 24
    public static let xxl: CGFloat = 32
    public static let xxxl: CGFloat = 48
}

/// Corner radii. Apply with `RoundedRectangle(cornerRadius:style: .continuous)`.
public enum DTRadius {
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 20
}

public enum DTSize {
    public static let minTouchTarget: CGFloat = 44
    public static let buttonHeight: CGFloat = 50
}
