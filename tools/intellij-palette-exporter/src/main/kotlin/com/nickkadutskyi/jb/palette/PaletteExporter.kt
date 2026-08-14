package com.nickkadutskyi.jb.palette

import com.intellij.ide.ui.UISettings
import com.intellij.openapi.application.ApplicationInfo
import com.intellij.openapi.application.ApplicationNamesInfo
import com.intellij.openapi.editor.colors.EditorColorsManager
import com.intellij.openapi.editor.colors.EditorColorsScheme
import com.intellij.ui.ColorUtil
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path

data class ExportResult(
    val profile: String,
    val product: String,
    val destination: String,
    val mode: MergeMode,
    val path: Path,
    val exportedCount: Int,
    val uniqueTopLevelCount: Int,
    val message: String,
)

object PaletteExporter {
    fun detectProfile(scheme: EditorColorsScheme = EditorColorsManager.getInstance().globalScheme): String {
        val background = scheme.defaultBackground
        val isDark = ColorUtil.isDark(background)
        val colorBlind = UISettings.getInstance().colorBlindness != null
        return ProfileDetector.detect(isDark, colorBlind)
    }

    fun detectProduct(): String {
        val code = try {
            ApplicationInfo.getInstance().build.productCode
        } catch (_: Throwable) {
            ""
        }
        val name = try {
            ApplicationNamesInfo.getInstance().productName
        } catch (_: Throwable) {
            ""
        }
        return ProductDetector.from(code, name)
    }

    fun exportTo(path: Path): ExportResult {
        val scheme = EditorColorsManager.getInstance().globalScheme
        val profile = detectProfile(scheme)
        val product = detectProduct()
        val catalog = DescriptorEnumerator.enumerate()
        val reader = SchemeReader(scheme, catalog.attributePaths, catalog.colorPaths)
        val entries = mutableListOf<ExportEntry>()

        for (descriptor in catalog.descriptors) {
            when (descriptor) {
                is DiscoveredDescriptor.Attribute -> {
                    val read = reader.readAttribute(descriptor.key) ?: continue
                    val (value, errorStripe) = read
                    entries += ExportEntry(descriptor.segments, profile, value)
                    if (errorStripe != null) {
                        entries += ExportEntry(
                            descriptor.segments + "ErrorStripeMark",
                            profile,
                            ProfileValue.Style(PaletteStyle(fg = errorStripe)),
                        )
                    }
                }
                is DiscoveredDescriptor.Color -> {
                    val value = reader.readColor(descriptor.key, descriptor.kind) ?: continue
                    entries += ExportEntry(descriptor.segments, profile, value)
                }
            }
        }

        val exported = PaletteMerger.buildExportDocument(entries)
        val existing = PaletteMerger.normalizeExisting(readExisting(path))
        val decision = ExportRouter.decide(product, existing, exported, profile)
        val routedExport = PaletteMerger.selectTopLevel(exported, decision.includedGroups)
        val merged = PaletteMerger.merge(existing, routedExport, profile, decision.destination, decision.mode)
        path.parent?.let { Files.createDirectories(it) }
        Files.writeString(path, PaletteJson.stringify(merged), StandardCharsets.UTF_8)
        return ExportResult(
            profile = profile,
            product = product,
            destination = decision.destination.joinToString("|"),
            mode = decision.mode,
            path = path,
            exportedCount = entries.size,
            uniqueTopLevelCount = decision.uniqueTopLevelCount,
            message = "${decision.message} (${entries.size} descriptors)",
        )
    }

    private fun readExisting(path: Path): JsonValue {
        if (!Files.exists(path)) return PaletteJson.emptyDocument()
        return try {
            PaletteJson.parse(Files.readString(path, StandardCharsets.UTF_8))
        } catch (_: Throwable) {
            PaletteJson.emptyDocument()
        }
    }
}
