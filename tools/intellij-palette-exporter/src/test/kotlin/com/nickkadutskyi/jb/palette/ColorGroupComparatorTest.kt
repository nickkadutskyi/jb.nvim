package com.nickkadutskyi.jb.palette

import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class ColorGroupComparatorTest {
    @Test
    fun matchingProfileLeavesAreEqual() {
        val intellij = ld(
            """
            { "Keyword": { "light": { "fg": "#111111" }, "dark": { "fg": "#222222" } } }
            """.trimIndent(),
        )
        val exported = ld(
            """
            { "Keyword": { "light": { "fg": "#111111" } } }
            """.trimIndent(),
        )
        assertTrue(ColorGroupComparator.matches(intellij, exported, PROFILE_LIGHT))
    }

    @Test
    fun valueMismatchIsDifferent() {
        val intellij = ld("""{ "Keyword": { "light": { "fg": "#111111" } } }""")
        val exported = ld("""{ "Keyword": { "light": { "fg": "#AAAAAA" } } }""")
        assertFalse(ColorGroupComparator.matches(intellij, exported, PROFILE_LIGHT))
    }

    @Test
    fun extraIntelliJKeysAreIgnored() {
        val intellij = ld(
            """
            {
              "Keyword": { "light": { "fg": "#111111" } },
              "Number": { "light": { "fg": "#00FF00" } }
            }
            """.trimIndent(),
        )
        val exported = ld("""{ "Keyword": { "light": { "fg": "#111111" } } }""")
        assertTrue(ColorGroupComparator.matches(intellij, exported, PROFILE_LIGHT))
    }

    @Test
    fun extraExportedKeysAreDifferent() {
        val intellij = ld("""{ "Keyword": { "light": { "fg": "#111111" } } }""")
        val exported = ld(
            """
            {
              "Keyword": { "light": { "fg": "#111111" } },
              "CSharpOnly": { "light": { "fg": "#ABCDEF" } }
            }
            """.trimIndent(),
        )
        assertFalse(ColorGroupComparator.matches(intellij, exported, PROFILE_LIGHT))
    }

    @Test
    fun missingIntelliJTreeIsDifferent() {
        val exported = ld("""{ "Keyword": { "light": { "fg": "#111111" } } }""")
        assertFalse(ColorGroupComparator.matches(null, exported, PROFILE_LIGHT))
    }

    @Test
    fun emptyExportMatches() {
        assertTrue(ColorGroupComparator.matches(ld("{}"), null, PROFILE_LIGHT))
    }

    @Test
    fun referenceMismatchIsDifferent() {
        val intellij = ld("""{ "Keyword": { "light": "General|Text|DefaultTextFg" } }""")
        val exported = ld("""{ "Keyword": { "light": { "fg": "#080808" } } }""")
        assertFalse(ColorGroupComparator.matches(intellij, exported, PROFILE_LIGHT))
    }

    private fun ld(json: String): JsonValue = PaletteJson.parse(json)
}
