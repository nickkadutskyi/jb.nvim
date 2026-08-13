package com.nickkadutskyi.jb.palette

object InheritanceResolver {
    fun resolve(
        directState: DirectState,
        fallbackPath: String?,
        resolved: PaletteStyle?,
    ): ProfileValue {
        return when (directState) {
            DirectState.DEFINED -> styleOrEmpty(resolved)
            DirectState.EMPTY -> ProfileValue.Empty
            DirectState.INHERITED, DirectState.ABSENT -> {
                if (fallbackPath != null) {
                    ProfileValue.Reference(fallbackPath)
                } else {
                    styleOrEmpty(resolved)
                }
            }
        }
    }

    private fun styleOrEmpty(resolved: PaletteStyle?): ProfileValue {
        if (resolved == null || resolved.isEmpty()) return ProfileValue.Empty
        return ProfileValue.Style(resolved)
    }
}
