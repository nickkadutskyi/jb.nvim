package com.nickkadutskyi.jb.palette

object ExportRouter {
    fun decide(product: String, existing: JsonValue, exported: JsonValue, profile: String): ExportDecision {
        if (ProductDetector.isCanonical(product)) {
            return ExportDecision(
                destination = listOf(PRODUCT_INTELLIJ),
                mode = MergeMode.OVERWRITE,
                message = "Exported $profile profile into $PRODUCT_INTELLIJ",
            )
        }

        val intellij = productScope(existing, PRODUCT_INTELLIJ)
        val exportedRoot = exported as? JsonValue.Obj
        if (intellij == null || intellij[LANGUAGE_DEFAULTS] == null) {
            return ExportDecision(
                destination = listOf(product),
                mode = MergeMode.OVERWRITE,
                message = "No $PRODUCT_INTELLIJ $LANGUAGE_DEFAULTS baseline; wrote $profile under $product. Export IntelliJ first.",
            )
        }

        val languageDefaultsMatch = ColorGroupComparator.matches(
            intellij[LANGUAGE_DEFAULTS],
            exportedRoot?.get(LANGUAGE_DEFAULTS),
            profile,
        )
        if (languageDefaultsMatch) {
            val unique = uniqueTopLevelGroups(exportedRoot, intellij.entries.keys)
            return ExportDecision(
                destination = listOf(PRODUCT_INTELLIJ),
                mode = MergeMode.ADD_ONLY,
                uniqueTopLevelCount = unique.size,
                message = "$LANGUAGE_DEFAULTS match $PRODUCT_INTELLIJ; merged ${unique.size} unique $product $profile top-level groups into $PRODUCT_INTELLIJ",
            )
        }

        val unique = uniqueTopLevelGroups(exportedRoot, intellij.entries.keys)
        val included = dependencyClosure(exportedRoot, intellij.entries.keys)
        return ExportDecision(
            destination = listOf(product),
            mode = MergeMode.OVERWRITE,
            includedGroups = included,
            uniqueTopLevelCount = unique.size,
            message = "$LANGUAGE_DEFAULTS differ from $PRODUCT_INTELLIJ; exported ${unique.size} unique top-level groups (${included.size} with dependencies) for $profile under $product",
        )
    }

    private fun uniqueTopLevelGroups(exported: JsonValue.Obj?, existingGroups: Set<String>): Set<String> {
        if (exported == null) return emptySet()
        return exported.entries.keys.filter { it !in existingGroups }.toSet()
    }

    fun languageDefaultsOf(document: JsonValue, product: String? = null): JsonValue? {
        val root = document as? JsonValue.Obj ?: return null
        val scope = if (product == null) root else root[product] as? JsonValue.Obj ?: return null
        return scope[LANGUAGE_DEFAULTS]
    }

    private fun productScope(document: JsonValue, product: String): JsonValue.Obj? {
        return (document as? JsonValue.Obj)?.get(product) as? JsonValue.Obj
    }

    private fun dependencyClosure(exported: JsonValue.Obj?, intellijGroups: Set<String>): Set<String> {
        if (exported == null) return emptySet()
        val included = LinkedHashSet(exported.entries.keys.filter { it !in intellijGroups })
        val pending = ArrayDeque(included)
        while (pending.isNotEmpty()) {
            val group = pending.removeFirst()
            val value = exported[group] ?: continue
            for (dependency in referencedGroups(value)) {
                if (dependency in exported.entries && included.add(dependency)) {
                    pending.addLast(dependency)
                }
            }
        }
        return included
    }

    private fun referencedGroups(value: JsonValue): Set<String> {
        val groups = LinkedHashSet<String>()
        collectReferences(value, groups)
        return groups
    }

    private fun collectReferences(value: JsonValue, groups: MutableSet<String>) {
        when (value) {
            is JsonValue.Str -> {
                val path = value.value.substringBefore('.')
                val group = path.substringBefore('|')
                if ('|' in path && group.isNotEmpty()) groups += group
            }
            is JsonValue.Arr -> value.items.forEach { collectReferences(it, groups) }
            is JsonValue.Obj -> value.entries.values.forEach { collectReferences(it, groups) }
            else -> Unit
        }
    }
}
