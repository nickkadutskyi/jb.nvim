package com.nickkadutskyi.jb.palette

object JsonNames {
    private val HTML_TAG = Regex("<[^>]+>")
    private val NON_ALNUM = Regex("[^A-Za-z0-9_]+")

    fun toJsonSafeName(displayName: String): String {
        val withoutHtml = HTML_TAG.replace(displayName, " ")
        val expanded = withoutHtml
            .replace("++", "pp")
            .replace("#", "sharp")
            .replace(".", "_")
            .replace("/", "_")
        val words = NON_ALNUM.split(expanded).filter { it.isNotEmpty() }
        val name = words.joinToString("") { word ->
            word.split('_').joinToString("_") { part ->
                if (part.isEmpty() || part.first().isUpperCase()) part
                else part.replaceFirstChar { it.uppercaseChar() }
            }
        }
        return when {
            name.isEmpty() || name.all { it == '_' } -> "Unnamed"
            name.first().isDigit() -> "_$name"
            name.lowercase() in PROFILE_KEY_SET -> "${name}Color"
            else -> name
        }
    }

    fun pathSegments(providerName: String, descriptorDisplayName: String): List<String> {
        val provider = toJsonSafeName(providerName)
        val parts = descriptorDisplayName
            .split("//")
            .map { toJsonSafeName(it.trim()) }
            .filter { it.isNotEmpty() && it != "Unnamed" }
        return listOf(provider) + parts
    }

    fun toPalettePath(segments: List<String>): String = segments.joinToString("|")
}
