package com.softwareofnote.dogtrackin.designsystem

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.sp

/**
 * Type scale mirroring Apple's Dynamic Type text styles at the default ("Large") size.
 * Uses the platform default (system) font family — no bundled fonts.
 * See docs/design-system/design-system.md §2.
 */
object DogTrackinType {
    private fun style(size: Int, lineHeight: Int, weight: FontWeight): TextStyle = TextStyle(
        fontFamily = FontFamily.Default,
        fontSize = size.sp,
        lineHeight = lineHeight.sp,
        fontWeight = weight,
        letterSpacing = TextUnit.Unspecified,
    )

    val display = style(34, 41, FontWeight.Bold)
    val title1 = style(28, 34, FontWeight.Bold)
    val title2 = style(22, 28, FontWeight.SemiBold)
    val title3 = style(20, 25, FontWeight.SemiBold)
    val headline = style(17, 22, FontWeight.SemiBold)
    val body = style(17, 22, FontWeight.Normal)
    val callout = style(16, 21, FontWeight.Normal)
    val subheadline = style(15, 20, FontWeight.Normal)
    val footnote = style(13, 18, FontWeight.Normal)
    val caption = style(12, 16, FontWeight.Medium)

    /** Maps the scale onto Material 3 slots so stock M3 components use it. */
    internal val material = Typography(
        displayLarge = display,
        displayMedium = display,
        displaySmall = title1,
        headlineLarge = display,
        headlineMedium = title1,
        headlineSmall = title2,
        titleLarge = title3,
        titleMedium = headline,
        titleSmall = subheadline,
        bodyLarge = body,
        bodyMedium = callout,
        bodySmall = footnote,
        labelLarge = headline,
        labelMedium = footnote,
        labelSmall = caption,
    )
}
