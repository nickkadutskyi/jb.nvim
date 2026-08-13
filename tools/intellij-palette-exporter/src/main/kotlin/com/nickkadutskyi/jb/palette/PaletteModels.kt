package com.nickkadutskyi.jb.palette

const val PROFILE_LIGHT = "light"
const val PROFILE_DARK = "dark"
const val PROFILE_LIGHT_CB = "light_cb"
const val PROFILE_DARK_CB = "dark_cb"

val PROFILE_KEYS = listOf(PROFILE_LIGHT, PROFILE_DARK, PROFILE_LIGHT_CB, PROFILE_DARK_CB)
val PROFILE_KEY_SET = PROFILE_KEYS.toSet()

enum class PaletteEffect(val jsonKey: String) {
    UNDERLINE("underline"),
    UNDERCURL("undercurl"),
    UNDERDOUBLE("underdouble"),
    UNDERDOTTED("underdotted"),
    UNDERDASHED("underdashed"),
    STRIKETHROUGH("strikethrough"),
    ;

    companion object {
        val JSON_ORDER = entries.toList()
    }
}

val STYLE_KEYS = listOf("fg", "bg", "sp", "bold", "italic") + PaletteEffect.JSON_ORDER.map { it.jsonKey }

data class PaletteStyle(
    val fg: String? = null,
    val bg: String? = null,
    val sp: String? = null,
    val bold: Boolean = false,
    val italic: Boolean = false,
    val effects: Set<PaletteEffect> = emptySet(),
) {
    fun isEmpty(): Boolean =
        fg == null && bg == null && sp == null && !bold && !italic && effects.isEmpty()
}

sealed class ProfileValue {
    data class Style(val style: PaletteStyle) : ProfileValue()

    data class Reference(val path: String) : ProfileValue()

    data object Empty : ProfileValue()
}

enum class DirectState {
    DEFINED,
    EMPTY,
    INHERITED,
    ABSENT,
}

data class ExportEntry(
    val segments: List<String>,
    val profile: String,
    val value: ProfileValue,
)

enum class MergeMode {
    OVERWRITE,
    ADD_ONLY,
}

const val PRODUCT_INTELLIJ = "IntelliJ"
const val LANGUAGE_DEFAULTS = "LanguageDefaults"
const val GENERAL = "General"

val KNOWN_PRODUCT_KEYS = setOf(
    PRODUCT_INTELLIJ,
    "CLion",
    "Rider",
    "WebStorm",
    "PyCharm",
    "GoLand",
    "PhpStorm",
    "RustRover",
    "DataGrip",
    "RubyMine",
    "DataSpell",
    "AndroidStudio",
    "Aqua",
    "Gateway",
    "MPS",
    "Fleet",
)

data class ExportDecision(
    val destination: List<String>,
    val mode: MergeMode,
    val includedGroups: Set<String>? = null,
    val message: String,
)
