package com.softwareofnote.dogtrackin.designsystem

import kotlin.math.max
import kotlin.math.min
import kotlin.math.pow

/**
 * Primitive colour palette for Dog Trackin', as 0xRRGGBB values.
 *
 * Kept free of Compose types so it can be unit-tested (see DesignTokensContrastTest) and
 * mirrored 1:1 in docs/design-system/tokens.json and a future SwiftUI implementation.
 *
 * Rule: [LAVENDER] and [SKY] are *surfaces*, never text colours — text on them is always [INK].
 */
object Palette {
    const val INK: Int = 0x000000
    const val PAPER: Int = 0xFFFFFF

    /** Light purple — primary actions, people, selection. */
    const val LAVENDER: Int = 0xD8CCFF
    const val LAVENDER_SOFT: Int = 0xEFEAFF

    /** Light blue — activity/events, information, sync, location. */
    const val SKY: Int = 0xC6E4FF
    const val SKY_SOFT: Int = 0xEAF5FF

    const val GRAY_900: Int = 0x1A1A1A
    const val GRAY_800: Int = 0x2A2A2A
    const val GRAY_600: Int = 0x5C5C5C
    const val GRAY_400: Int = 0xA3A3A3
    const val GRAY_300: Int = 0xC7C7C7

    /** LAVENDER at 16% opacity composited over INK (dark-mode soft surface). */
    const val LAVENDER_SOFT_DARK: Int = 0x232129

    /** SKY at 16% opacity composited over INK (dark-mode soft surface). */
    const val SKY_SOFT_DARK: Int = 0x202429
}

/** WCAG 2.x colour math on 0xRRGGBB values. */
object ColorMath {
    fun relativeLuminance(rgb: Int): Double {
        fun channel(shift: Int): Double {
            val c = ((rgb shr shift) and 0xFF) / 255.0
            return if (c <= 0.03928) c / 12.92 else ((c + 0.055) / 1.055).pow(2.4)
        }
        return 0.2126 * channel(16) + 0.7152 * channel(8) + 0.0722 * channel(0)
    }

    fun contrastRatio(a: Int, b: Int): Double {
        val la = relativeLuminance(a)
        val lb = relativeLuminance(b)
        return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)
    }
}
