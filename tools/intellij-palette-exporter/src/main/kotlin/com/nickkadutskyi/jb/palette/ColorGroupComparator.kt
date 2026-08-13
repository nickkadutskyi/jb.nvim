package com.nickkadutskyi.jb.palette

object ColorGroupComparator {
    fun matches(intellijGroup: JsonValue?, exportedGroup: JsonValue?, profile: String): Boolean {
        if (exportedGroup == null) return true
        if (intellijGroup == null) return false
        return exportedLeavesMatch(intellijGroup, exportedGroup, profile)
    }

    private fun exportedLeavesMatch(intellij: JsonValue, exported: JsonValue, profile: String): Boolean {
        val exportedLeaf = profileLeaf(exported, profile)
        if (exportedLeaf != null) {
            val intellijLeaf = profileLeaf(intellij, profile) ?: return false
            return jsonEquals(exportedLeaf, intellijLeaf)
        }
        if (exported !is JsonValue.Obj) return true
        for ((key, child) in exported.entries) {
            if (key in PROFILE_KEY_SET) continue
            val other = (intellij as? JsonValue.Obj)?.get(key) ?: return false
            if (!exportedLeavesMatch(other, child, profile)) return false
        }
        return true
    }

    private fun profileLeaf(node: JsonValue, profile: String): JsonValue? {
        return when (node) {
            is JsonValue.Str, JsonValue.Null -> node
            is JsonValue.Obj -> {
                val value = node[profile]
                if (value != null && isLeafProfileValue(value)) value else null
            }
            else -> null
        }
    }

    private fun jsonEquals(left: JsonValue, right: JsonValue): Boolean {
        return when {
            left is JsonValue.Null && right is JsonValue.Null -> true
            left is JsonValue.Bool && right is JsonValue.Bool -> left.value == right.value
            left is JsonValue.Num && right is JsonValue.Num -> left.literal == right.literal
            left is JsonValue.Str && right is JsonValue.Str -> left.value == right.value
            left is JsonValue.Arr && right is JsonValue.Arr ->
                left.items.size == right.items.size && left.items.indices.all { jsonEquals(left.items[it], right.items[it]) }
            left is JsonValue.Obj && right is JsonValue.Obj -> {
                left.entries.size == right.entries.size &&
                    left.entries.all { (key, value) ->
                        val other = right[key] ?: return false
                        jsonEquals(value, other)
                    }
            }
            else -> false
        }
    }
}
