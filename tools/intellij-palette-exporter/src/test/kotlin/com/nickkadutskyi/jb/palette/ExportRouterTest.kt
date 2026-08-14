package com.nickkadutskyi.jb.palette

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull

class ExportRouterTest {
    @Test
    fun intellijAlwaysOverwritesIntelliJTree() {
        val decision = ExportRouter.decide(PRODUCT_INTELLIJ, PaletteJson.emptyDocument(), baseline("#111111", "#FFFFFF"), PROFILE_LIGHT)
        assertEquals(listOf(PRODUCT_INTELLIJ), decision.destination)
        assertEquals(MergeMode.OVERWRITE, decision.mode)
        assertNull(decision.includedGroups)
        assertEquals(0, decision.uniqueTopLevelCount)
    }

    @Test
    fun matchingLanguageDefaultsReportsUniqueTopLevelGroups() {
        val existing = scoped(baseline("#111111", "#FFFFFF"))
        val exported = baseline("#111111", "#FFFFFF", "CSharp", "FSharp")
        val decision = ExportRouter.decide("Rider", existing, exported, PROFILE_LIGHT)
        assertEquals(listOf(PRODUCT_INTELLIJ), decision.destination)
        assertEquals(MergeMode.ADD_ONLY, decision.mode)
        assertEquals(2, decision.uniqueTopLevelCount)
        assertEquals(
            "$LANGUAGE_DEFAULTS match $PRODUCT_INTELLIJ; merged 2 unique Rider light top-level groups into $PRODUCT_INTELLIJ",
            decision.message,
        )
    }

    @Test
    fun missingIntelliJBaselineWritesUnderCurrentProduct() {
        val decision = ExportRouter.decide("Rider", PaletteJson.emptyDocument(), baseline("#111111", "#FFFFFF"), PROFILE_LIGHT)
        assertEquals(listOf("Rider"), decision.destination)
        assertEquals(MergeMode.OVERWRITE, decision.mode)
        assertNull(decision.includedGroups)
    }

    @Test
    fun matchingLanguageDefaultsAddOnlyIntoIntelliJ() {
        val existing = scoped(baseline("#111111", "#FFFFFF"))
        val decision = ExportRouter.decide("Rider", existing, baseline("#111111", "#FFFFFF"), PROFILE_LIGHT)
        assertEquals(listOf(PRODUCT_INTELLIJ), decision.destination)
        assertEquals(MergeMode.ADD_ONLY, decision.mode)
        assertNull(decision.includedGroups)
        assertEquals(0, decision.uniqueTopLevelCount)
        assertEquals(
            "$LANGUAGE_DEFAULTS match $PRODUCT_INTELLIJ; merged 0 unique Rider light top-level groups into $PRODUCT_INTELLIJ",
            decision.message,
        )
    }

    @Test
    fun differentLanguageDefaultsUsesProductScope() {
        val existing = scoped(baseline("#111111", "#FFFFFF"))
        val exported = baseline("#ABCDEF", "#FFFFFF", "CSharp")
        val decision = ExportRouter.decide("Rider", existing, exported, PROFILE_LIGHT)
        assertEquals(listOf("Rider"), decision.destination)
        assertEquals(MergeMode.OVERWRITE, decision.mode)
        assertEquals(setOf("CSharp", LANGUAGE_DEFAULTS), decision.includedGroups)
        assertEquals(1, decision.uniqueTopLevelCount)
    }

    @Test
    fun differentGeneralDoesNotAffectRouting() {
        val existing = scoped(baseline("#111111", "#FFFFFF"))
        val exported = baseline("#111111", "#000000", "CSharp")
        val decision = ExportRouter.decide("Rider", existing, exported, PROFILE_LIGHT)
        assertEquals(listOf(PRODUCT_INTELLIJ), decision.destination)
        assertEquals(MergeMode.ADD_ONLY, decision.mode)
        assertNull(decision.includedGroups)
        assertEquals(1, decision.uniqueTopLevelCount)
    }

    @Test
    fun sharedGroupsAreIgnoredWhenBaselineDiffers() {
        val existing = scoped(baseline("#111111", "#FFFFFF", "AngularTemplate", "BashSupportPro"))
        val exported = baseline("#ABCDEF", "#FFFFFF", "AngularTemplate", "BashSupportPro", "CSharp")
        val decision = ExportRouter.decide("Rider", existing, exported, PROFILE_LIGHT)
        assertEquals(setOf("CSharp", LANGUAGE_DEFAULTS), decision.includedGroups)
        assertEquals(1, decision.uniqueTopLevelCount)
    }

    @Test
    fun referencedSharedLanguageIsIncludedAsDependency() {
        val existing = scoped(baseline("#111111", "#FFFFFF", "SharedLanguage"))
        val exported = baseline("#ABCDEF", "#FFFFFF", "SharedLanguage", "CSharp") as JsonValue.Obj
        val csharp = exported["CSharp"] as JsonValue.Obj
        csharp["Keyword"] = JsonValue.Obj(linkedMapOf(PROFILE_LIGHT to JsonValue.Str("SharedLanguage|Keyword")))

        val decision = ExportRouter.decide("Rider", existing, exported, PROFILE_LIGHT)
        assertEquals(setOf("CSharp", "SharedLanguage", LANGUAGE_DEFAULTS), decision.includedGroups)
        assertEquals(1, decision.uniqueTopLevelCount)
    }

    @Test
    fun inheritanceDependenciesAreTransitive() {
        val existing = scoped(baseline("#111111", "#FFFFFF", "SharedLanguage", "SharedBase"))
        val exported = baseline("#ABCDEF", "#FFFFFF", "SharedLanguage", "SharedBase", "CSharp") as JsonValue.Obj
        (exported["CSharp"] as JsonValue.Obj)["Keyword"] = profileRef("SharedLanguage|Keyword")
        (exported["SharedLanguage"] as JsonValue.Obj)["Keyword"] = profileRef("SharedBase|Keyword")

        val decision = ExportRouter.decide("Rider", existing, exported, PROFILE_LIGHT)
        assertEquals(setOf("CSharp", "SharedLanguage", "SharedBase", LANGUAGE_DEFAULTS), decision.includedGroups)
        assertEquals(1, decision.uniqueTopLevelCount)
    }

    private fun baseline(ld: String, general: String, vararg groups: String): JsonValue {
        val entries = mutableListOf(
            ExportEntry(listOf(LANGUAGE_DEFAULTS, "Keyword"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(fg = ld))),
            ExportEntry(listOf(GENERAL, "Text", "DefaultText"), PROFILE_LIGHT, ProfileValue.Style(PaletteStyle(bg = general))),
        )
        groups.forEach { group ->
            entries += ExportEntry(listOf(group, "Keyword"), PROFILE_LIGHT, ProfileValue.Reference("LanguageDefaults|Keyword"))
        }
        return PaletteMerger.buildExportDocument(entries)
    }

    private fun scoped(exported: JsonValue): JsonValue = PaletteMerger.merge(
        PaletteJson.emptyDocument(),
        exported,
        PROFILE_LIGHT,
        listOf(PRODUCT_INTELLIJ),
    )

    private fun profileRef(path: String): JsonValue.Obj =
        JsonValue.Obj(linkedMapOf(PROFILE_LIGHT to JsonValue.Str(path)))
}
