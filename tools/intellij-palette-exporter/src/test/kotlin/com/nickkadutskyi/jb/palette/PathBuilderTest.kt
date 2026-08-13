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
        assertEquals("SassSCSS", JsonNames.toJsonSafeName("Sass/SCSS"))
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
