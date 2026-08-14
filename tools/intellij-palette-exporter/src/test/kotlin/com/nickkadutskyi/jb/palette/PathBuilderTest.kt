package com.nickkadutskyi.jb.palette

import kotlin.test.Test
import kotlin.test.assertEquals

class PathBuilderTest {
    @Test
    fun generalIdentifierUnderCaret() {
        val segments = JsonNames.pathSegments("General", "Code//Identifier under caret")
        assertEquals(listOf("General", "Code", "IdentifierUnderCaret"), segments)
        assertEquals("General|Code|IdentifierUnderCaret", JsonNames.toPalettePath(segments))
    }

    @Test
    fun languageDefaultsKeyword() {
        val segments = JsonNames.pathSegments("Language Defaults", "Keywords//Keyword")
        assertEquals(listOf("LanguageDefaults", "Keywords", "Keyword"), segments)
    }

    @Test
    fun diffAndMerge() {
        val segments = JsonNames.pathSegments("Diff & Merge", "Changed lines//Inserted")
        assertEquals(listOf("DiffMerge", "ChangedLines", "Inserted"), segments)
    }

    @Test
    fun preservesExistingCapitals() {
        assertEquals("TODODefaults", JsonNames.toJsonSafeName("TODO defaults"))
        assertEquals("Sass_SCSS", JsonNames.toJsonSafeName("Sass/SCSS"))
    }

    @Test
    fun replacesLanguagePunctuationWithWords() {
        assertEquals("C_Cpp", JsonNames.toJsonSafeName("C/C++"))
        assertEquals("Csharp", JsonNames.toJsonSafeName("C#"))
        assertEquals("Fsharp", JsonNames.toJsonSafeName("F#"))
        assertEquals("ASP_NET", JsonNames.toJsonSafeName("ASP.NET"))
    }

    @Test
    fun stripsHtml() {
        assertEquals("Keyword", JsonNames.toJsonSafeName("<html>Keyword</html>"))
    }

    @Test
    fun prefixesDigitNames() {
        assertEquals("_2Tone", JsonNames.toJsonSafeName("2 Tone"))
    }

    @Test
    fun avoidsProfileKeyCollision() {
        assertEquals("LightColor", JsonNames.toJsonSafeName("light"))
        assertEquals("DarkColor", JsonNames.toJsonSafeName("dark"))
    }

    @Test
    fun emptyNameBecomesUnnamed() {
        assertEquals("Unnamed", JsonNames.toJsonSafeName("///"))
    }

    @Test
    fun errorStripeChildPath() {
        val parent = JsonNames.pathSegments("General", "Errors and Warnings//Error")
        val stripe = parent + "ErrorStripeMark"
        assertEquals("General|ErrorsAndWarnings|Error|ErrorStripeMark", JsonNames.toPalettePath(stripe))
    }
}
