package com.nickkadutskyi.jb.palette

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertIs
import kotlin.test.assertNull

class ProductScopedMergeTest {
    @Test
    fun wrapsLegacyUnscopedColorsUnderIntelliJ() {
        val legacy = PaletteJson.parse(
            """
            {
              "colors": {
                "LanguageDefaults": { "Keyword": { "light": { "fg": "#111111" } } },
                "PHP": { "Keywords": { "light": "LanguageDefaults|Keyword" } },
                "Rider": { "CSharp": { "light": { "fg": "#ABCDEF" } } }
              }
            }
            """.trimIndent(),
        )
        val wrapped = PaletteMerger.normalizeExisting(legacy) as JsonValue.Obj
        assertIs<JsonValue.Obj>(wrapped[PRODUCT_INTELLIJ])
        assertEquals("#111111", styleFg(wrapped, PRODUCT_INTELLIJ, LANGUAGE_DEFAULTS, "Keyword", PROFILE_LIGHT))
        assertEquals("LanguageDefaults|Keyword", ref(wrapped, PRODUCT_INTELLIJ, "PHP", "Keywords", PROFILE_LIGHT))
        assertEquals("#ABCDEF", styleFg(wrapped, "Rider", "CSharp", PROFILE_LIGHT))
        assertNull(wrapped[LANGUAGE_DEFAULTS])
        assertNull(wrapped["colors"])
    }

    @Test
    fun keepsOtherScopeAtRootWhenWrapping() {
        val existing = PaletteJson.parse(
            """
            {
              "Other": { "Custom": { "light": { "fg": "#ABCDEF" } } }
            }
            """.trimIndent(),
        )
        val normalized = PaletteMerger.normalizeExisting(existing) as JsonValue.Obj
        assertNull(normalized[PRODUCT_INTELLIJ])
        assertEquals("#ABCDEF", styleFg(normalized, SCOPE_OTHER, "Custom", PROFILE_LIGHT))
    }

    @Test
    fun wrapsColorGroupsButLeavesOtherAtRoot() {
        val existing = PaletteJson.parse(
            """
            {
              "LanguageDefaults": { "Keyword": { "light": { "fg": "#111111" } } },
              "Other": { "Custom": { "light": { "fg": "#ABCDEF" } } }
            }
            """.trimIndent(),
        )
        val normalized = PaletteMerger.normalizeExisting(existing) as JsonValue.Obj
        assertEquals("#111111", styleFg(normalized, PRODUCT_INTELLIJ, LANGUAGE_DEFAULTS, "Keyword", PROFILE_LIGHT))
        assertEquals("#ABCDEF", styleFg(normalized, SCOPE_OTHER, "Custom", PROFILE_LIGHT))
        assertNull((normalized[PRODUCT_INTELLIJ] as JsonValue.Obj)[SCOPE_OTHER])
    }

    @Test
    fun renamesLegacyPunctuationStrippedGroups() {
        val existing = PaletteJson.parse(
            """
            {
              "IntelliJ": {
                "CC": { "MacroName": { "light": { "fg": "#111111" } } },
                "C": { "Keyword": { "light": "C|Methods|MethodDeclaration" } },
                "F": { "Keyword": { "light": "F|Members|Method" } },
                "ASPNET": { "Razor": { "light": "ASPNET|Razor|CodeBlock" } },
                "SassSCSS": { "Variable": { "light": "SassSCSS|Variable" } }
              }
            }
            """.trimIndent(),
        )
        val normalized = PaletteMerger.normalizeExisting(existing) as JsonValue.Obj
        val intellij = normalized[PRODUCT_INTELLIJ] as JsonValue.Obj
        assertNull(intellij["CC"])
        assertNull(intellij["C"])
        assertNull(intellij["F"])
        assertNull(intellij["ASPNET"])
        assertNull(intellij["SassSCSS"])
        assertEquals("#111111", styleFg(normalized, PRODUCT_INTELLIJ, "C_Cpp", "MacroName", PROFILE_LIGHT))
        assertEquals("Csharp|Methods|MethodDeclaration", ref(normalized, PRODUCT_INTELLIJ, "Csharp", "Keyword", PROFILE_LIGHT))
        assertEquals("Fsharp|Members|Method", ref(normalized, PRODUCT_INTELLIJ, "Fsharp", "Keyword", PROFILE_LIGHT))
        assertEquals("ASP_NET|Razor|CodeBlock", ref(normalized, PRODUCT_INTELLIJ, "ASP_NET", "Razor", PROFILE_LIGHT))
        assertEquals("Sass_SCSS|Variable", ref(normalized, PRODUCT_INTELLIJ, "Sass_SCSS", "Variable", PROFILE_LIGHT))
    }

    @Test
    fun addOnlyDoesNotOverwriteIntelliJLeaves() {
        val existing = PaletteMerger.merge(
            PaletteJson.emptyDocument(),
            export(
                ExportEntry(listOf("PHP", "Keywords"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#OLD"))),
            ),
            PROFILE_LIGHT,
            listOf(PRODUCT_INTELLIJ),
        )
        val merged = PaletteMerger.merge(
            existing,
            export(
                ExportEntry(listOf("PHP", "Keywords"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#NEW"))),
                ExportEntry(listOf("CSharp", "Keyword"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#CS"))),
            ),
            PROFILE_LIGHT,
            listOf(PRODUCT_INTELLIJ),
            MergeMode.ADD_ONLY,
        ) as JsonValue.Obj
        assertEquals("#OLD", styleFg(merged, PRODUCT_INTELLIJ, "PHP", "Keywords", PROFILE_LIGHT))
        assertEquals("#CS", styleFg(merged, PRODUCT_INTELLIJ, "CSharp", "Keyword", PROFILE_LIGHT))
    }

    @Test
    fun differentDefaultsLandUnderRider() {
        val existing = PaletteMerger.merge(
            PaletteJson.emptyDocument(),
            export(
                ExportEntry(listOf(LANGUAGE_DEFAULTS, "Keyword"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#111111"))),
                ExportEntry(listOf(GENERAL, "Text", "DefaultText"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(bg = "#FFFFFF"))),
                ExportEntry(listOf("PHP", "Keywords"), PROFILE_LIGHT, ProfileValue.Reference("LanguageDefaults|Keyword")),
            ),
            PROFILE_LIGHT,
            listOf(PRODUCT_INTELLIJ),
        )
        val exported = export(
            ExportEntry(listOf(LANGUAGE_DEFAULTS, "Keyword"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#ABCDEF"))),
            ExportEntry(listOf(GENERAL, "Text", "DefaultText"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(bg = "#FFFFFF"))),
            ExportEntry(listOf("CSharp", "Keyword"), PROFILE_LIGHT, ProfileValue.Reference("LanguageDefaults|Keyword")),
        )
        val decision = ExportRouter.decide("Rider", existing, exported, PROFILE_LIGHT)
        val routed = PaletteMerger.selectTopLevel(exported, decision.includedGroups)
        val merged = PaletteMerger.merge(existing, routed, PROFILE_LIGHT, decision.destination, decision.mode) as JsonValue.Obj
        assertEquals("#111111", styleFg(merged, PRODUCT_INTELLIJ, LANGUAGE_DEFAULTS, "Keyword", PROFILE_LIGHT))
        assertEquals("LanguageDefaults|Keyword", ref(merged, PRODUCT_INTELLIJ, "PHP", "Keywords", PROFILE_LIGHT))
        assertEquals("#ABCDEF", styleFg(merged, "Rider", LANGUAGE_DEFAULTS, "Keyword", PROFILE_LIGHT))
        assertEquals("LanguageDefaults|Keyword", ref(merged, "Rider", "CSharp", "Keyword", PROFILE_LIGHT))
    }

    @Test
    fun matchingDefaultsAddRiderOnlyLanguageIntoIntelliJ() {
        val existing = PaletteMerger.merge(
            PaletteJson.emptyDocument(),
            export(
                ExportEntry(listOf(LANGUAGE_DEFAULTS, "Keyword"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#111111"))),
                ExportEntry(listOf(GENERAL, "Text", "DefaultText"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(bg = "#FFFFFF"))),
                ExportEntry(listOf("PHP", "Keywords"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#PHP"))),
            ),
            PROFILE_LIGHT,
            listOf(PRODUCT_INTELLIJ),
        )
        val exported = export(
            ExportEntry(listOf(LANGUAGE_DEFAULTS, "Keyword"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#111111"))),
            ExportEntry(listOf(GENERAL, "Text", "DefaultText"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(bg = "#FFFFFF"))),
            ExportEntry(listOf("PHP", "Keywords"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#RIDERPHP"))),
            ExportEntry(listOf("CSharp", "Keyword"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = "#CS"))),
        )
        val decision = ExportRouter.decide("Rider", existing, exported, PROFILE_LIGHT)
        val merged = PaletteMerger.merge(existing, exported, PROFILE_LIGHT, decision.destination, decision.mode) as JsonValue.Obj
        assertEquals(listOf(PRODUCT_INTELLIJ), decision.destination)
        assertEquals(MergeMode.ADD_ONLY, decision.mode)
        assertEquals("#PHP", styleFg(merged, PRODUCT_INTELLIJ, "PHP", "Keywords", PROFILE_LIGHT))
        assertEquals("#CS", styleFg(merged, PRODUCT_INTELLIJ, "CSharp", "Keyword", PROFILE_LIGHT))
        assertNull(merged["Rider"])
    }

    private fun export(vararg entries: ExportEntry): JsonValue.Obj =
        PaletteMerger.buildExportDocument(entries.toList())

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
