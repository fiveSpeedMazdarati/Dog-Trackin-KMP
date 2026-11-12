package com.softwareofnote.dogtrackin.designsystem

import androidx.compose.material3.ColorScheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color

private fun rgb(value: Int): Color = Color(0xFF000000.toInt() or value)

/** Semantic colour tokens. See docs/design-system/design-system.md §1.3. */
@Immutable
data class DogTrackinColors(
    val background: Color,
    val surface: Color,
    val onBackground: Color,
    val textSecondary: Color,
    val divider: Color,
    val accentPrimary: Color,
    val onAccentPrimary: Color,
    val accentPrimarySoft: Color,
    val accentInfo: Color,
    val onAccentInfo: Color,
    val accentInfoSoft: Color,
    val bannerCriticalBackground: Color,
    val bannerCriticalForeground: Color,
    val focusRing: Color,
    val isDark: Boolean,
)

val LightDogTrackinColors = DogTrackinColors(
    background = rgb(Palette.PAPER),
    surface = rgb(Palette.PAPER),
    onBackground = rgb(Palette.INK),
    textSecondary = rgb(Palette.GRAY_600),
    divider = rgb(Palette.GRAY_300),
    accentPrimary = rgb(Palette.LAVENDER),
    onAccentPrimary = rgb(Palette.INK),
    accentPrimarySoft = rgb(Palette.LAVENDER_SOFT),
    accentInfo = rgb(Palette.SKY),
    onAccentInfo = rgb(Palette.INK),
    accentInfoSoft = rgb(Palette.SKY_SOFT),
    bannerCriticalBackground = rgb(Palette.INK),
    bannerCriticalForeground = rgb(Palette.PAPER),
    focusRing = rgb(Palette.INK),
    isDark = false,
)

val DarkDogTrackinColors = DogTrackinColors(
    background = rgb(Palette.INK),
    surface = rgb(Palette.GRAY_900),
    onBackground = rgb(Palette.PAPER),
    textSecondary = rgb(Palette.GRAY_400),
    divider = rgb(Palette.GRAY_800),
    accentPrimary = rgb(Palette.LAVENDER),
    onAccentPrimary = rgb(Palette.INK),
    accentPrimarySoft = rgb(Palette.LAVENDER_SOFT_DARK),
    accentInfo = rgb(Palette.SKY),
    onAccentInfo = rgb(Palette.INK),
    accentInfoSoft = rgb(Palette.SKY_SOFT_DARK),
    bannerCriticalBackground = rgb(Palette.PAPER),
    bannerCriticalForeground = rgb(Palette.INK),
    focusRing = rgb(Palette.PAPER),
    isDark = true,
)

val LocalDogTrackinColors = staticCompositionLocalOf { LightDogTrackinColors }

/**
 * Maps the semantic tokens onto Material 3 slots so stock M3 components pick up the brand.
 * There is deliberately no red: "error" uses the inverted critical banner colours.
 */
internal fun DogTrackinColors.toMaterialColorScheme(): ColorScheme =
    if (isDark) {
        darkColorScheme(
            primary = accentPrimary,
            onPrimary = onAccentPrimary,
            primaryContainer = accentPrimarySoft,
            onPrimaryContainer = onBackground,
            secondary = accentInfo,
            onSecondary = onAccentInfo,
            secondaryContainer = accentInfoSoft,
            onSecondaryContainer = onBackground,
            tertiary = accentInfo,
            onTertiary = onAccentInfo,
            background = background,
            onBackground = onBackground,
            surface = surface,
            onSurface = onBackground,
            surfaceVariant = accentPrimarySoft,
            onSurfaceVariant = textSecondary,
            surfaceTint = Color.Transparent,
            inverseSurface = bannerCriticalBackground,
            inverseOnSurface = bannerCriticalForeground,
            error = bannerCriticalBackground,
            onError = bannerCriticalForeground,
            errorContainer = accentPrimary,
            onErrorContainer = onAccentPrimary,
            outline = onBackground,
            outlineVariant = divider,
        )
    } else {
        lightColorScheme(
            primary = accentPrimary,
            onPrimary = onAccentPrimary,
            primaryContainer = accentPrimarySoft,
            onPrimaryContainer = onBackground,
            secondary = accentInfo,
            onSecondary = onAccentInfo,
            secondaryContainer = accentInfoSoft,
            onSecondaryContainer = onBackground,
            tertiary = accentInfo,
            onTertiary = onAccentInfo,
            background = background,
            onBackground = onBackground,
            surface = surface,
            onSurface = onBackground,
            surfaceVariant = accentPrimarySoft,
            onSurfaceVariant = textSecondary,
            surfaceTint = Color.Transparent,
            inverseSurface = bannerCriticalBackground,
            inverseOnSurface = bannerCriticalForeground,
            error = bannerCriticalBackground,
            onError = bannerCriticalForeground,
            errorContainer = accentPrimary,
            onErrorContainer = onAccentPrimary,
            outline = onBackground,
            outlineVariant = divider,
        )
    }
