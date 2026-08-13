package com.nickkadutskyi.jb.palette

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertIs

class InheritanceTest {
    @Test
    fun inheritedUsesFallbackPathWhenKnown() {
        val value = InheritanceResolver.resolve(
            DirectState.INHERITED,
            "LanguageDefaults|Keyword",
            PaletteStyle(fg = "#ABCDEF"),
        )
        assertEquals(ProfileValue.Reference("LanguageDefaults|Keyword"), value)
    }

    @Test
    fun absentUsesFallbackPathWhenKnown() {
        val value = InheritanceResolver.resolve(
            DirectState.ABSENT,
            "LanguageDefaults|Identifiers|Default",
            PaletteStyle(fg = "#000000"),
        )
        assertEquals(ProfileValue.Reference("LanguageDefaults|Identifiers|Default"), value)
    }

    @Test
    fun inheritedWithoutKnownFallbackUsesResolvedStyle() {
        val value = InheritanceResolver.resolve(
            DirectState.INHERITED,
            null,
            PaletteStyle(fg = "#123456"),
        )
        assertEquals(ProfileValue.Style(PaletteStyle(fg = "#123456")), value)
    }

    @Test
    fun absentWithoutFallbackUsesResolvedParentSchemeColors() {
        val value = InheritanceResolver.resolve(
            DirectState.ABSENT,
            null,
            PaletteStyle(bg = "#FFFFFE"),
        )
        assertEquals(ProfileValue.Style(PaletteStyle(bg = "#FFFFFE")), value)
    }

    @Test
    fun definedEmptyBecomesEmptyObject() {
        val value = InheritanceResolver.resolve(DirectState.EMPTY, "LanguageDefaults|Keyword", PaletteStyle())
        assertEquals(ProfileValue.Empty, value)
    }

    @Test
    fun definedStyleIgnoresFallback() {
        val value = InheritanceResolver.resolve(
            DirectState.DEFINED,
            "LanguageDefaults|Keyword",
            PaletteStyle(fg = "#660000", italic = true),
        )
        assertEquals(ProfileValue.Style(PaletteStyle(fg = "#660000", italic = true)), value)
    }

    @Test
    fun unresolvedResolvedStyleBecomesEmpty() {
        val inherited = InheritanceResolver.resolve(DirectState.INHERITED, null, null)
        val absent = InheritanceResolver.resolve(DirectState.ABSENT, null, PaletteStyle())
        assertEquals(ProfileValue.Empty, inherited)
        assertEquals(ProfileValue.Empty, absent)
    }

    @Test
    fun referenceSerializesToPalettePath() {
        val json = ProfileValue.Reference("General|Text|DefaultText").toJson()
        assertIs<JsonValue.Str>(json)
        assertEquals("General|Text|DefaultText", json.value)
    }
}
