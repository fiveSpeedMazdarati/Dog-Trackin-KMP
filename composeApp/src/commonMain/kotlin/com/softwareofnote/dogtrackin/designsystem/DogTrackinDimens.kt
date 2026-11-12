package com.softwareofnote.dogtrackin.designsystem

import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Shapes
import androidx.compose.ui.unit.dp

/** 4-pt spacing scale. See docs/design-system/design-system.md §4. */
object Spacing {
    val xxs = 2.dp
    val xs = 4.dp
    val s = 8.dp
    val m = 12.dp
    val l = 16.dp
    val xl = 24.dp
    val xxl = 32.dp
    val xxxl = 48.dp
}

object Radius {
    val small = 8.dp
    val medium = 12.dp
    val large = 20.dp
}

object Sizes {
    val minTouchTarget = 44.dp
    val buttonHeight = 50.dp
}

internal val DogTrackinShapes = Shapes(
    extraSmall = RoundedCornerShape(Radius.small),
    small = RoundedCornerShape(Radius.small),
    medium = RoundedCornerShape(Radius.medium),
    large = RoundedCornerShape(Radius.large),
    extraLarge = RoundedCornerShape(Radius.large),
)
