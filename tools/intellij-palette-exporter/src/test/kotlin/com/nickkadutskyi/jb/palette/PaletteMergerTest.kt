package com.nickkadutskyi.jb.palette

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertIs

class PaletteMergerTest {
    @Test
    fun preservesRootAndUnrelatedColorTrees() {
        val existing = PaletteJson.parse(
            """
            {
              "meta": "keep",
              "Custom": { "Hand": { "light": { "fg": "#111111" } } },
              "PHP": {
                "DQLBuilder": {
                  "light": { "fg": "#222222" },
                  "dark": { "fg": "#333333" }
                }
              }
            }
            """.trimIndent(),
        )
        val exported = exportEntries(
            ExportEntry(listOf("PHP", "Keywords"), PROFILE_LIGHT, ProfileValue.Reference("LanguageDefaults|Keyword")),
        )
        val merged = PaletteMerger.merge(existing, exported, PROFILE_LIGHT) as JsonValue.Obj

        assertEquals("keep", (merged["meta"] as JsonValue.Str).value)
        assertEquals("#111111", styleFg(merged, "Custom", "Hand", PROFILE_LIGHT))
        assertEquals("#222222", styleFg(merged, "PHP", "DQLBuilder", PROFILE_LIGHT))
        assertEquals("#333333", styleFg(merged, "PHP", "DQLBuilder", PROFILE_DARK))
        assertEquals("LanguageDefaults|Keyword", ref(merged, "PHP", "Keywords", PROFILE_LIGHT))
    }

    @Test
    fun overlaysOnlyDetectedProfile() {
        val existing = exportEntries(
            ExportEntry(listOf("General", "Text", "DefaultText"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#OLD"))),
            ExportEntry(listOf("General", "Text", "DefaultText"), PROFILE_DARK, ProfileValue.Style(PaletteStyle(fg = "#DARK"))),
        )
        val exported = exportEntries(
            ExportEntry(listOf("General", "Text", "DefaultText"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#080808", bg = "#FFFFFE"))),
        )
        val merged = PaletteMerger.merge(existing, exported, PROFILE_LIGHT) as JsonValue.Obj
        val leaf = navigate(merged, "General", "Text", "DefaultText") as JsonValue.Obj
        assertEquals("#080808", ((leaf[PROFILE_LIGHT] as JsonValue.Obj)["fg"] as JsonValue.Str).value)
        assertEquals("#FFFFFE", ((leaf[PROFILE_LIGHT] as JsonValue.Obj)["bg"] as JsonValue.Str).value)
        assertEquals("#DARK", ((leaf[PROFILE_DARK] as JsonValue.Obj)["fg"] as JsonValue.Str).value)
    }

    @Test
    fun doesNotDeleteStaleProfilesFromReducedExports() {
        val existing = exportEntries(
            ExportEntry(listOf("PHP", "Keywords"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#AAA"))),
            ExportEntry(listOf("PHP", "Keywords"), PROFILE_DARK, ProfileValue.Style(PaletteStyle(fg = "#BBB"))),
            ExportEntry(listOf("PHP", "DQLBuilder"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#CCC"))),
        )
        val exported = exportEntries(
            ExportEntry(listOf("PHP", "Keywords"), PROFILE_LIGHT, ProfileValue.Reference("LanguageDefaults|Keyword")),
        )
        val merged = PaletteMerger.merge(existing, exported, PROFILE_LIGHT) as JsonValue.Obj
        assertEquals("LanguageDefaults|Keyword", ref(merged, "PHP", "Keywords", PROFILE_LIGHT))
        assertEquals("#BBB", styleFg(merged, "PHP", "Keywords", PROFILE_DARK))
        assertEquals("#CCC", styleFg(merged, "PHP", "DQLBuilder", PROFILE_LIGHT))
    }

    @Test
    fun emptyAttributesBecomeEmptyProfileObject() {
        val existing = PaletteJson.emptyDocument()
        val exported = exportEntries(
            ExportEntry(listOf("PHP", "Numbers"), PROFILE_LIGHT, ProfileValue.Empty),
        )
        val merged = PaletteMerger.merge(existing, exported, PROFILE_LIGHT) as JsonValue.Obj
        val numbers = navigate(merged, "PHP", "Numbers") as JsonValue.Obj
        val light = numbers[PROFILE_LIGHT]
        assertIs<JsonValue.Obj>(light)
        assertEquals(0, light.entries.size)
    }

    @Test
    fun expandsWholeDescriptorReferenceWhenOverlayingOneProfile() {
        val existing = PaletteJson.parse(
            """
            { "PHP": { "Keywords": "LanguageDefaults|Keyword" } }
            """.trimIndent(),
        )
        val exported = exportEntries(
            ExportEntry(listOf("PHP", "Keywords"), PROFILE_DARK, ProfileValue.Style(PaletteStyle(fg = "#9876AA"))),
        )
        val merged = PaletteMerger.merge(existing, exported, PROFILE_DARK) as JsonValue.Obj
        val keywords = navigate(merged, "PHP", "Keywords") as JsonValue.Obj
        assertEquals("LanguageDefaults|Keyword", (keywords[PROFILE_LIGHT] as JsonValue.Str).value)
        assertEquals("#9876AA", ((keywords[PROFILE_DARK] as JsonValue.Obj)["fg"] as JsonValue.Str).value)
        assertEquals("LanguageDefaults|Keyword", (keywords[PROFILE_LIGHT_CB] as JsonValue.Str).value)
        assertEquals("LanguageDefaults|Keyword", (keywords[PROFILE_DARK_CB] as JsonValue.Str).value)
    }

    @Test
    fun fourPassMergeKeepsAllProfiles() {
        var document: JsonValue = PaletteJson.parse(
            """
            {
              "Custom": { "keep": true },
              "PHP": {
                "DQLBuilder": { "light": { "fg": "#111111" } }
              }
            }
            """.trimIndent(),
        )
        val passes = listOf(
            PROFILE_LIGHT to ProfileValue.Reference("LanguageDefaults|Keyword"),
            PROFILE_DARK to ProfileValue.Style(PaletteStyle(fg = "#ABCDEF")),
            PROFILE_LIGHT_CB to ProfileValue.Empty,
            PROFILE_DARK_CB to ProfileValue.Reference("LanguageDefaults|Keyword"),
        )
        for ((profile, value) in passes) {
            val exported = exportEntries(ExportEntry(listOf("PHP", "Keywords"), profile, value))
            document = PaletteMerger.merge(document, exported, profile)
        }

        val keywords = navigate(document, "PHP", "Keywords") as JsonValue.Obj
        assertEquals("LanguageDefaults|Keyword", (keywords[PROFILE_LIGHT] as JsonValue.Str).value)
        assertEquals("#ABCDEF", ((keywords[PROFILE_DARK] as JsonValue.Obj)["fg"] as JsonValue.Str).value)
        assertIs<JsonValue.Obj>(keywords[PROFILE_LIGHT_CB])
        assertEquals(0, (keywords[PROFILE_LIGHT_CB] as JsonValue.Obj).entries.size)
        assertEquals("LanguageDefaults|Keyword", (keywords[PROFILE_DARK_CB] as JsonValue.Str).value)
        assertEquals("#111111", styleFg(document as JsonValue.Obj, "PHP", "DQLBuilder", PROFILE_LIGHT))
        assertEquals(true, ((((document as JsonValue.Obj)["Custom"] as JsonValue.Obj)["keep"]) as JsonValue.Bool).value)
    }

    @Test
    fun prettyPrintIsDeterministic() {
        val first = PaletteJson.stringify(
            exportEntries(
                ExportEntry(listOf("General", "Text", "DefaultText"), PROFILE_DARK, ProfileValue.Style(PaletteStyle(fg = "#BCBEC4"))),
                ExportEntry(listOf("General", "Text", "DefaultText"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#080808", bg = "#FFFFFE"))),
            ),
        )
        val second = PaletteJson.stringify(PaletteJson.parse(first))
        assertEquals(first, second)
        assertEquals(
            """
            {
              "General": {
                "Text": {
                  "DefaultText": {
                    "light": {
                      "fg": "#080808",
                      "bg": "#FFFFFE"
                    },
                    "dark": {
                      "fg": "#BCBEC4"
                    }
                  }
                }
              }
            }

            """.trimIndent(),
            first,
        )
    }

    @Test
    fun missingProviderIsNotExportedAsEmpty() {
        val existing = exportEntries(
            ExportEntry(listOf("MissingPlugin", "Token"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#999999"))),
        )
        val exported = exportEntries(
            ExportEntry(listOf("PHP", "Keywords"), PROFILE_LIGHT, ProfileValue.Empty),
        )
        val merged = PaletteMerger.merge(existing, exported, PROFILE_LIGHT) as JsonValue.Obj
        assertEquals("#999999", styleFg(merged, "MissingPlugin", "Token", PROFILE_LIGHT))
        val keywords = navigate(merged, "PHP", "Keywords") as JsonValue.Obj
        assertIs<JsonValue.Obj>(keywords[PROFILE_LIGHT])
    }

    private fun exportEntries(vararg entries: ExportEntry): JsonValue.Obj =
        PaletteMerger.buildExportDocument(entries.toList())

    private fun navigate(root: JsonValue, vararg keys: String): JsonValue {
        var current = root
        for (key in keys) {
            current = (current as JsonValue.Obj).entries.getValue(key)
        }
        return current
    }

    private fun styleFg(colors: JsonValue.Obj, vararg path: String): String {
        var current: JsonValue = colors
        for (key in path.dropLast(1)) {
            current = (current as JsonValue.Obj).entries.getValue(key)
        }
        val style = (current as JsonValue.Obj).entries.getValue(path.last()) as JsonValue.Obj
        return (style["fg"] as JsonValue.Str).value
    }

    private fun ref(colors: JsonValue.Obj, vararg pathAndProfile: String): String {
        var current: JsonValue = colors
        for (key in pathAndProfile) {
            current = (current as JsonValue.Obj).entries.getValue(key)
        }
        return (current as JsonValue.Str).value
    }
}
