package com.softwareofnote.dogtrackin

import com.softwareofnote.dogtrackin.designsystem.ColorMath
import com.softwareofnote.dogtrackin.designsystem.Palette
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

/**
 * Guards the design system's contrast promises (docs/design-system/design-system.md §1.4).
 * If a palette change breaks WCAG AA for a text/background pair we actually use, this fails.
 */
class DesignTokensContrastTest {
    private val aaNormalText = 4.5

    private fun assertAa(fg: Int, bg: Int, name: String) {
        val ratio = ColorMath.contrastRatio(fg, bg)
        assertTrue(ratio >= aaNormalText, "$name contrast was $ratio, needs >= $aaNormalText")
    }

    @Test
    fun blackOnWhiteIsMaximum() {
        assertEquals(21.0, ColorMath.contrastRatio(Palette.INK, Palette.PAPER), 0.01)
    }

    @Test
    fun textPairsMeetAa() {
        assertAa(Palette.INK, Palette.PAPER, "ink on paper")
        assertAa(Palette.PAPER, Palette.INK, "paper on ink")
        assertAa(Palette.INK, Palette.LAVENDER, "ink on lavender")
        assertAa(Palette.INK, Palette.LAVENDER_SOFT, "ink on lavenderSoft")
        assertAa(Palette.INK, Palette.SKY, "ink on sky")
        assertAa(Palette.INK, Palette.SKY_SOFT, "ink on skySoft")
        assertAa(Palette.GRAY_600, Palette.PAPER, "secondary text on paper")
        assertAa(Palette.GRAY_400, Palette.INK, "secondary text on ink (dark)")
        assertAa(Palette.GRAY_400, Palette.GRAY_900, "secondary text on dark surface")
        assertAa(Palette.PAPER, Palette.GRAY_900, "text on dark surface")
        assertAa(Palette.PAPER, Palette.LAVENDER_SOFT_DARK, "text on dark lavender-soft")
        assertAa(Palette.PAPER, Palette.SKY_SOFT_DARK, "text on dark sky-soft")
    }

    @Test
    fun pastelsAreNeverTextOnWhite() {
        // Documents the "pastels are surfaces, never text" rule: these pairs must FAIL AA.
        assertTrue(ColorMath.contrastRatio(Palette.LAVENDER, Palette.PAPER) < aaNormalText)
        assertTrue(ColorMath.contrastRatio(Palette.SKY, Palette.PAPER) < aaNormalText)
    }
}
