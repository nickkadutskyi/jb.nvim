package com.nickkadutskyi.jb.palette

import com.intellij.openapi.editor.colors.ColorKey
import com.intellij.openapi.editor.colors.EditorColorsScheme
import com.intellij.openapi.editor.colors.TextAttributesKey
import com.intellij.openapi.editor.colors.impl.AbstractColorsScheme
import com.intellij.openapi.editor.markup.TextAttributes
import com.intellij.openapi.options.colors.ColorDescriptor
import java.awt.Color
import java.awt.Font

internal class SchemeReader(
    private val scheme: EditorColorsScheme,
    private val attributePaths: Map<TextAttributesKey, String>,
    private val colorPaths: Map<ColorKey, String>,
) {
    private val defaultTextBackground = resolveDefaultTextBackground()

    fun readAttribute(key: TextAttributesKey): Pair<ProfileValue, String?>? {
        return try {
            val direct = directAttributes(key)
            val fallbackPath = key.fallbackAttributeKey?.let { attributePaths[it] }
            val source = when {
                direct != null && direct !== AbstractColorsScheme.INHERITED_ATTRS_MARKER -> direct
                else -> scheme.getAttributes(key, true)
            }
            val style = source?.let { toStyle(it) }
            val state = attributeState(direct, style)
            val value = InheritanceResolver.resolve(state, fallbackPath, style)
            val errorStripe = if (state == DirectState.DEFINED) source?.errorStripeColor?.let { toHex(it) } else null
            value to errorStripe
        } catch (_: Throwable) {
            null
        }
    }

    fun readColor(key: ColorKey, kind: ColorDescriptor.Kind): ProfileValue? {
        return try {
            val direct = directColor(key)
            val fallbackPath = key.fallbackColorKey?.let { colorPaths[it] }
            val resolvedColor = when {
                direct != null && direct !== AbstractColorsScheme.INHERITED_COLOR_MARKER &&
                    direct !== AbstractColorsScheme.NULL_COLOR_MARKER -> direct
                else -> scheme.getColor(key)
            }
            val hex = resolvedColor?.let { toHex(it) }
            val style = AttributeConverter.colorKindToStyle(kind.name, hex)
            val state = colorState(direct, style)
            InheritanceResolver.resolve(state, fallbackPath, style)
        } catch (_: Throwable) {
            null
        }
    }

    private fun attributeState(direct: TextAttributes?, style: PaletteStyle?): DirectState {
        return when {
            direct === AbstractColorsScheme.INHERITED_ATTRS_MARKER -> DirectState.INHERITED
            direct == null -> DirectState.ABSENT
            direct.isEmpty || style == null || style.isEmpty() -> DirectState.EMPTY
            else -> DirectState.DEFINED
        }
    }

    private fun colorState(direct: Color?, style: PaletteStyle?): DirectState {
        return when {
            direct === AbstractColorsScheme.INHERITED_COLOR_MARKER -> DirectState.INHERITED
            direct === AbstractColorsScheme.NULL_COLOR_MARKER -> DirectState.EMPTY
            direct == null -> DirectState.ABSENT
            style == null || style.isEmpty() -> DirectState.EMPTY
            else -> DirectState.DEFINED
        }
    }

    private fun directAttributes(key: TextAttributesKey): TextAttributes? {
        val abstract = scheme as? AbstractColorsScheme ?: return null
        return try {
            abstract.getDirectlyDefinedAttributes(key)
        } catch (_: Throwable) {
            null
        }
    }

    private fun directColor(key: ColorKey): Color? {
        val abstract = scheme as? AbstractColorsScheme ?: return null
        return try {
            abstract.getDirectlyDefinedColor(key)
        } catch (_: Throwable) {
            null
        }
    }

    private fun toStyle(attrs: TextAttributes): PaletteStyle {
        val fontType = attrs.fontType
        val effectsEnabled = attrs.hasEffects()
        return PaletteStyle(
            fg = attrs.foregroundColor?.let { toHex(it) },
            bg = attrs.backgroundColor?.let { toHex(it) },
            sp = if (effectsEnabled) attrs.effectColor?.let { toHex(it) } else null,
            bold = fontType and Font.BOLD != 0,
            italic = fontType and Font.ITALIC != 0,
            effects = if (effectsEnabled) {
                setOfNotNull(AttributeConverter.effectFromName(attrs.effectType?.name))
            } else {
                emptySet()
            },
        )
    }

    private fun resolveDefaultTextBackground(): Color {
        val defaultTextPath = JsonNames.toPalettePath(listOf(GENERAL, "Text", "DefaultText"))
        val key = attributePaths.entries.firstOrNull { it.value == defaultTextPath }?.key
        return key?.let { scheme.getAttributes(it, true)?.backgroundColor } ?: scheme.defaultBackground
    }

    private fun toHex(color: Color): String =
        AttributeConverter.flattenedHexColor(color, defaultTextBackground)
}
