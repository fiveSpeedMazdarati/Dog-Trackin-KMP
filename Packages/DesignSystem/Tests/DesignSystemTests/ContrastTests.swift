import Testing
@testable import DesignSystem

/// Guards design-system.md §1.4: text/background pairs we actually use must meet WCAG AA (4.5:1).
struct ContrastTests {
    static let aa = 4.5

    static let textPairs: [(name: String, fg: UInt32, bg: UInt32)] = [
        ("ink on paper", Palette.ink, Palette.paper),
        ("paper on ink", Palette.paper, Palette.ink),
        ("ink on lavender", Palette.ink, Palette.lavender),
        ("ink on lavenderSoft", Palette.ink, Palette.lavenderSoft),
        ("ink on sky", Palette.ink, Palette.sky),
        ("ink on skySoft", Palette.ink, Palette.skySoft),
        ("secondary on paper", Palette.gray600, Palette.paper),
        ("secondary on ink", Palette.gray400, Palette.ink),
        ("secondary on dark surface", Palette.gray400, Palette.gray900),
        ("paper on dark surface", Palette.paper, Palette.gray900),
        ("paper on dark lavenderSoft", Palette.paper, Palette.lavenderSoftDark),
        ("paper on dark skySoft", Palette.paper, Palette.skySoftDark),
    ]

    @Test func blackOnWhiteIsMaximum() {
        #expect(abs(ColorMath.contrastRatio(Palette.ink, Palette.paper) - 21.0) < 0.01)
    }

    @Test(arguments: ContrastTests.textPairs.indices)
    func textPairMeetsAA(index: Int) {
        let pair = Self.textPairs[index]
        let ratio = ColorMath.contrastRatio(pair.fg, pair.bg)
        #expect(ratio >= Self.aa, "\(pair.name) is \(ratio):1")
    }

    /// Documents the "pastels are surfaces, never text" rule: these must FAIL AA.
    @Test func pastelsAreNotTextOnWhite() {
        #expect(ColorMath.contrastRatio(Palette.lavender, Palette.paper) < Self.aa)
        #expect(ColorMath.contrastRatio(Palette.sky, Palette.paper) < Self.aa)
    }
}
