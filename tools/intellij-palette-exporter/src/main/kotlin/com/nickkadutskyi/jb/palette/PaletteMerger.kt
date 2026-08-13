package com.nickkadutskyi.jb.palette

object PaletteMerger {
    fun merge(
        existing: JsonValue,
        exported: JsonValue,
        profile: String,
        destination: List<String> = emptyList(),
        mode: MergeMode = MergeMode.OVERWRITE,
    ): JsonValue {
        val existingRoot = existing.copyDeep()
        if (existingRoot !is JsonValue.Obj || exported !is JsonValue.Obj) {
            return existingRoot
        }
        var target: JsonValue.Obj = existingRoot
        for (segment in destination) {
            target = target.getOrPutObj(segment)
        }
        overlay(target, exported, profile, mode)
        return existingRoot
    }

    fun buildExportDocument(entries: List<ExportEntry>): JsonValue.Obj {
        val root = PaletteJson.emptyDocument()
        for (entry in entries) {
            putEntry(root, entry)
        }
        return root
    }

    fun selectTopLevel(document: JsonValue, groups: Set<String>?): JsonValue.Obj {
        val root = document as? JsonValue.Obj ?: return PaletteJson.emptyDocument()
        if (groups == null) return root.copyDeep() as JsonValue.Obj
        val selected = JsonValue.Obj()
        for (group in groups) {
            root[group]?.let { selected[group] = it.copyDeep() }
        }
        return selected
    }

    fun normalizeExisting(root: JsonValue): JsonValue {
        if (root !is JsonValue.Obj) return PaletteJson.emptyDocument()
        val working = unwrapColors(root)
        if (working[PRODUCT_INTELLIJ] is JsonValue.Obj) return working
        val unscoped = working.entries.filter { (key, value) ->
            key !in KNOWN_PRODUCT_KEYS && value is JsonValue.Obj
        }
        if (unscoped.isEmpty()) return working
        val intellij = JsonValue.Obj()
        for ((key, value) in unscoped) {
            intellij[key] = value.copyDeep()
        }
        val rebuilt = JsonValue.Obj()
        rebuilt[PRODUCT_INTELLIJ] = intellij
        for ((key, value) in working.entries) {
            if (key in KNOWN_PRODUCT_KEYS || value !is JsonValue.Obj) {
                rebuilt[key] = value.copyDeep()
            }
        }
        return rebuilt
    }

    private fun unwrapColors(root: JsonValue.Obj): JsonValue.Obj {
        val nested = root["colors"] as? JsonValue.Obj ?: return root
        val rebuilt = JsonValue.Obj()
        for ((key, value) in root.entries) {
            if (key != "colors") {
                rebuilt[key] = value.copyDeep()
            }
        }
        for ((key, value) in nested.entries) {
            if (key !in rebuilt.entries) {
                rebuilt[key] = value.copyDeep()
            }
        }
        return rebuilt
    }

    private fun putEntry(colors: JsonValue.Obj, entry: ExportEntry) {
        if (entry.segments.isEmpty()) return
        var node = colors
        for (segment in entry.segments.dropLast(1)) {
            node = node.getOrPutObj(segment)
        }
        val leaf = node.getOrPutObj(entry.segments.last())
        leaf[entry.profile] = entry.value.toJson()
    }

    private fun overlay(existing: JsonValue.Obj, exported: JsonValue.Obj, profile: String, mode: MergeMode) {
        for ((key, exportedValue) in exported.entries) {
            if (key == profile && isLeafProfileValue(exportedValue)) {
                if (mode == MergeMode.OVERWRITE || key !in existing.entries) {
                    existing[key] = exportedValue.copyDeep()
                }
                continue
            }
            if (exportedValue !is JsonValue.Obj) {
                if (key !in existing.entries) {
                    existing[key] = exportedValue.copyDeep()
                }
                continue
            }
            when (val current = existing[key]) {
                null, JsonValue.Null -> existing[key] = exportedValue.copyDeep()
                is JsonValue.Str -> {
                    if (mode == MergeMode.ADD_ONLY) continue
                    val expanded = expandReference(current.value)
                    overlay(expanded, exportedValue, profile, mode)
                    existing[key] = expanded
                }
                is JsonValue.Obj -> overlay(current, exportedValue, profile, mode)
                else -> {
                    if (key !in existing.entries) {
                        existing[key] = exportedValue.copyDeep()
                    }
                }
            }
        }
    }

    private fun expandReference(path: String): JsonValue.Obj {
        val obj = JsonValue.Obj()
        for (profile in PROFILE_KEYS) {
            obj[profile] = JsonValue.Str(path)
        }
        return obj
    }
}
