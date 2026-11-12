package com.softwareofnote.dogtrackin.designsystem

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.ReadOnlyComposable

/**
 * Root theme. Provides Dog Trackin' semantic colours via [DogTrackinTheme.colors] and wires the
 * tokens into Material 3 so stock components follow the design system.
 */
@Composable
fun DogTrackinTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit,
) {
    val colors = if (darkTheme) DarkDogTrackinColors else LightDogTrackinColors
    CompositionLocalProvider(LocalDogTrackinColors provides colors) {
        MaterialTheme(
            colorScheme = colors.toMaterialColorScheme(),
            typography = DogTrackinType.material,
            shapes = DogTrackinShapes,
            content = content,
        )
    }
}

object DogTrackinTheme {
    val colors: DogTrackinColors
        @Composable
        @ReadOnlyComposable
        get() = LocalDogTrackinColors.current
}
