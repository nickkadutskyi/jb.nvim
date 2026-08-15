package com.nickkadutskyi.jb.palette

import java.awt.Color
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull
import kotlin.test.assertTrue

class AttributeConverterTest {
    @Test
    fun hexIsUppercaseWithHash() {
        assertEquals("#0A1B2C", AttributeConverter.hexColor(10, 27, 44))
    }

    @Test
    fun flattensTransparentColorAgainstBackground() {
        assertEquals(
            "#CCCCCC",
            AttributeConverter.flattenedHexColor(Color(0, 0, 0, 51), Color.WHITE),
        )
    }

    @Test
    fun preservesOpaqueColor() {
        assertEquals(
            "#0A1B2C",
            AttributeConverter.flattenedHexColor(Color(10, 27, 44), Color.WHITE),
        )
    }

    @Test
    fun mapsLineUnderscore() {
        assertEquals(PaletteEffect.UNDERLINE, AttributeConverter.effectFromName("LINE_UNDERSCORE"))
    }

    @Test
    fun mapsWaveUnderscore() {
        assertEquals(PaletteEffect.UNDERCURL, AttributeConverter.effectFromName("WAVE_UNDERSCORE"))
    }

    @Test
    fun mapsBoldLineUnderscore() {
        assertEquals(PaletteEffect.UNDERDOUBLE, AttributeConverter.effectFromName("BOLD_LINE_UNDERSCORE"))
    }

    @Test
    fun mapsDottedLine() {
        assertEquals(PaletteEffect.UNDERDOTTED, AttributeConverter.effectFromName("BOLD_DOTTED_LINE"))
        assertEquals(PaletteEffect.UNDERDOTTED, AttributeConverter.effectFromName("DOTTED_LINE"))
    }

    @Test
    fun mapsDashedLine() {
        assertEquals(PaletteEffect.UNDERDASHED, AttributeConverter.effectFromName("DASHED_LINE"))
    }

    @Test
    fun mapsStrikeout() {
        assertEquals(PaletteEffect.STRIKETHROUGH, AttributeConverter.effectFromName("STRIKEOUT"))
    }

    @Test
    fun ignoresUnknownEffects() {
        assertNull(AttributeConverter.effectFromName("BOXED"))
        assertNull(AttributeConverter.effectFromName("FADED"))
        assertNull(AttributeConverter.effectFromName(null))
    }

    @Test
    fun convertsTextAttributesVocabulary() {
        val style = AttributeConverter.toStyle(
            foreground = "#080808",
            background = "#FFFFFE",
            effectColor = "#FF0000",
            bold = true,
            italic = true,
            effectName = "WAVE_UNDERSCORE",
        )
        assertEquals("#080808", style.fg)
        assertEquals("#FFFFFE", style.bg)
        assertEquals("#FF0000", style.sp)
        assertTrue(style.bold)
        assertTrue(style.italic)
        assertEquals(setOf(PaletteEffect.UNDERCURL), style.effects)
    }

    @Test
    fun colorKindUsesForegroundOrBackground() {
        assertEquals("#112233", AttributeConverter.colorKindToStyle("FOREGROUND", "#112233").fg)
        assertEquals("#445566", AttributeConverter.colorKindToStyle("BACKGROUND", "#445566").bg)
        assertEquals("#778899", AttributeConverter.colorKindToStyle("BACKGROUND_WITH_TRANSPARENCY", "#778899").bg)
        assertTrue(AttributeConverter.colorKindToStyle("FOREGROUND", null).isEmpty())
    }

    @Test
    fun disabledEffectsIgnoresLeftoverEffectType() {
        val style = AttributeConverter.toStyle(
            foreground = "#080808",
            effectName = "LINE_UNDERSCORE",
            effectsEnabled = false,
        )
        assertNull(style.sp)
        assertEquals(emptySet(), style.effects)
        assertEquals("#080808", style.fg)
    }

    @Test
    fun leftoverEffectTypeWithoutColorIsNotEmitted() {
        val style = AttributeConverter.toStyle(
            effectName = "LINE_UNDERSCORE",
        )
        assertTrue(style.isEmpty())
    }

    @Test
    fun enabledEffectsEmitTypeAndColor() {
        val style = AttributeConverter.toStyle(
            effectColor = "#FF0000",
            effectName = "LINE_UNDERSCORE",
            effectsEnabled = true,
        )
        assertEquals("#FF0000", style.sp)
        assertEquals(setOf(PaletteEffect.UNDERLINE), style.effects)
    }

    @Test
    fun jsonOmitsFalseFlagsAndUnavailableColors() {
        val json = AttributeConverter.toStyle(foreground = "#080808").toJson() as JsonValue.Obj
        assertEquals(setOf("fg"), json.entries.keys)
        assertEquals("#080808", (json["fg"] as JsonValue.Str).value)
    }
}
