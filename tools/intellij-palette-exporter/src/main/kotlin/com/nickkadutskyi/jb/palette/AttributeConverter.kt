package com.nickkadutskyi.jb.palette

object AttributeConverter {
    fun hexColor(red: Int, green: Int, blue: Int): String =
        "#%02X%02X%02X".format(red, green, blue)

    fun effectFromName(name: String?): PaletteEffect? = when (name) {
        "LINE_UNDERSCORE" -> PaletteEffect.UNDERLINE
        "WAVE_UNDERSCORE" -> PaletteEffect.UNDERCURL
        "BOLD_LINE_UNDERSCORE" -> PaletteEffect.UNDERDOUBLE
        "BOLD_DOTTED_LINE", "DOTTED_LINE" -> PaletteEffect.UNDERDOTTED
        "DASHED_LINE", "BOLD_DASHED_LINE" -> PaletteEffect.UNDERDASHED
        "STRIKEOUT" -> PaletteEffect.STRIKETHROUGH
        else -> null
    }

    fun toStyle(
        foreground: String? = null,
        background: String? = null,
        effectColor: String? = null,
        bold: Boolean = false,
        italic: Boolean = false,
        effectName: String? = null,
        effectsEnabled: Boolean = effectColor != null,
    ): PaletteStyle {
        return PaletteStyle(
            fg = foreground,
            bg = background,
            sp = if (effectsEnabled) effectColor else null,
            bold = bold,
            italic = italic,
            effects = if (effectsEnabled) setOfNotNull(effectFromName(effectName)) else emptySet(),
        )
    }

    fun colorKindToStyle(kindName: String, hex: String?): PaletteStyle {
        if (hex == null) return PaletteStyle()
        return when {
            kindName.startsWith("BACKGROUND") -> PaletteStyle(bg = hex)
            else -> PaletteStyle(fg = hex)
        }
    }
}
