package com.nickkadutskyi.jb.palette

object ProductDetector {
    private val CODES = mapOf(
        "IU" to PRODUCT_INTELLIJ,
        "IC" to PRODUCT_INTELLIJ,
        "IE" to PRODUCT_INTELLIJ,
        "CL" to "CLion",
        "RD" to "Rider",
        "WS" to "WebStorm",
        "PY" to "PyCharm",
        "PC" to "PyCharm",
        "GO" to "GoLand",
        "PS" to "PhpStorm",
        "RR" to "RustRover",
        "DB" to "DataGrip",
        "RM" to "RubyMine",
        "DS" to "DataSpell",
        "AI" to "AndroidStudio",
        "QA" to "Aqua",
        "GW" to "Gateway",
        "MPS" to "MPS",
        "FL" to "Fleet",
    )

    fun from(productCode: String, productName: String = ""): String {
        CODES[productCode.trim().uppercase()]?.let { return it }
        val named = JsonNames.toJsonSafeName(productName.trim())
        return when {
            named.startsWith("IntelliJ") -> PRODUCT_INTELLIJ
            named in KNOWN_PRODUCT_KEYS -> named
            named.isNotEmpty() && named != "Unnamed" -> named
            else -> PRODUCT_INTELLIJ
        }
    }

    fun isCanonical(product: String): Boolean = product == PRODUCT_INTELLIJ
}
