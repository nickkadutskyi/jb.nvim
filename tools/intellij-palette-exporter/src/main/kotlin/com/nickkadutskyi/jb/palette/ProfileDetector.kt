package com.nickkadutskyi.jb.palette

object ProfileDetector {
    fun detect(backgroundIsDark: Boolean, colorBlindnessEnabled: Boolean): String {
        val base = if (backgroundIsDark) PROFILE_DARK else PROFILE_LIGHT
        return if (colorBlindnessEnabled) "${base}_cb" else base
    }

    fun isDarkBackground(red: Int, green: Int, blue: Int): Boolean {
        return luminance(red, green, blue) < 0.5
    }

    fun luminance(red: Int, green: Int, blue: Int): Double {
        return luminanceContribution(red / 255.0) * 0.2126 +
            luminanceContribution(green / 255.0) * 0.7152 +
            luminanceContribution(blue / 255.0) * 0.0722
    }

    private fun luminanceContribution(channel: Double): Double {
        return if (channel <= 0.03928) {
            channel / 12.92
        } else {
            Math.pow((channel + 0.055) / 1.055, 2.4)
        }
    }
}
