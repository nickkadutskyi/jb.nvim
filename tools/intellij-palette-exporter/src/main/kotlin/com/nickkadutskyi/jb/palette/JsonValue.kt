package com.nickkadutskyi.jb.palette

sealed class JsonValue {
    data object Null : JsonValue()

    data class Bool(val value: Boolean) : JsonValue()

    data class Num(val literal: String) : JsonValue()

    data class Str(val value: String) : JsonValue()

    data class Arr(val items: MutableList<JsonValue> = mutableListOf()) : JsonValue()

    data class Obj(val entries: LinkedHashMap<String, JsonValue> = LinkedHashMap()) : JsonValue() {
        operator fun get(key: String): JsonValue? = entries[key]

        operator fun set(key: String, value: JsonValue) {
            entries[key] = value
        }

        fun getOrPutObj(key: String): Obj {
            val existing = entries[key]
            if (existing is Obj) return existing
            val created = Obj()
            entries[key] = created
            return created
        }
    }

    fun copyDeep(): JsonValue = when (this) {
        Null -> Null
        is Bool -> Bool(value)
        is Num -> Num(literal)
        is Str -> Str(value)
        is Arr -> Arr(items.map { it.copyDeep() }.toMutableList())
        is Obj -> Obj(entries.entries.associateTo(LinkedHashMap()) { it.key to it.value.copyDeep() })
    }
}

fun ProfileValue.toJson(): JsonValue = when (this) {
    is ProfileValue.Reference -> JsonValue.Str(path)
    ProfileValue.Empty -> JsonValue.Obj()
    is ProfileValue.Style -> style.toJson()
}

fun PaletteStyle.toJson(): JsonValue {
    val obj = JsonValue.Obj()
    fg?.let { obj["fg"] = JsonValue.Str(it) }
    bg?.let { obj["bg"] = JsonValue.Str(it) }
    sp?.let { obj["sp"] = JsonValue.Str(it) }
    if (bold) obj["bold"] = JsonValue.Bool(true)
    if (italic) obj["italic"] = JsonValue.Bool(true)
    for (effect in PaletteEffect.JSON_ORDER) {
        if (effect in effects) {
            obj[effect.jsonKey] = JsonValue.Bool(true)
        }
    }
    return obj
}

fun isLeafProfileValue(value: JsonValue): Boolean {
    return when (value) {
        is JsonValue.Str, JsonValue.Null -> true
        is JsonValue.Obj -> value.entries.keys.none { it in PROFILE_KEY_SET } &&
            value.entries.values.none { it is JsonValue.Obj }
        else -> false
    }
}

