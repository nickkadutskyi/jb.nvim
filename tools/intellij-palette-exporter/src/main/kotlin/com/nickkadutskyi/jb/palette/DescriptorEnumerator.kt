package com.nickkadutskyi.jb.palette

import com.intellij.application.options.colors.ColorSettingsUtil
import com.intellij.openapi.options.colors.ColorAndFontDescriptorsProvider
import com.intellij.openapi.options.colors.ColorDescriptor
import com.intellij.openapi.options.colors.ColorSettingsPages
import com.intellij.openapi.editor.colors.ColorKey
import com.intellij.openapi.editor.colors.TextAttributesKey

internal sealed class DiscoveredDescriptor {
    abstract val segments: List<String>
    abstract val path: String

    data class Attribute(
        override val segments: List<String>,
        override val path: String,
        val key: TextAttributesKey,
    ) : DiscoveredDescriptor()

    data class Color(
        override val segments: List<String>,
        override val path: String,
        val key: ColorKey,
        val kind: ColorDescriptor.Kind,
    ) : DiscoveredDescriptor()
}

internal data class DescriptorCatalog(
    val descriptors: List<DiscoveredDescriptor>,
    val attributePaths: Map<TextAttributesKey, String>,
    val colorPaths: Map<ColorKey, String>,
)

internal object DescriptorEnumerator {
    fun enumerate(): DescriptorCatalog {
        val providers = linkedMapOf<String, ColorAndFontDescriptorsProvider>()
        collectPages(providers)
        collectExtensionProviders(providers)

        val descriptors = mutableListOf<DiscoveredDescriptor>()
        val attributePaths = LinkedHashMap<TextAttributesKey, String>()
        val colorPaths = LinkedHashMap<ColorKey, String>()
        val seenPaths = HashSet<String>()

        for ((displayName, provider) in providers) {
            try {
                collectAttributes(provider, displayName, descriptors, attributePaths, seenPaths)
                collectColors(provider, displayName, descriptors, colorPaths, seenPaths)
            } catch (_: Throwable) {
            }
        }

        return DescriptorCatalog(descriptors, attributePaths, colorPaths)
    }

    private fun collectPages(providers: MutableMap<String, ColorAndFontDescriptorsProvider>) {
        try {
            for (page in ColorSettingsPages.getInstance().registeredPages) {
                try {
                    providers.putIfAbsent(page.displayName, page)
                } catch (_: Throwable) {
                }
            }
        } catch (_: Throwable) {
        }
    }

    private fun collectExtensionProviders(providers: MutableMap<String, ColorAndFontDescriptorsProvider>) {
        try {
            for (provider in ColorAndFontDescriptorsProvider.EP_NAME.extensionList) {
                try {
                    providers.putIfAbsent(provider.displayName, provider)
                } catch (_: Throwable) {
                }
            }
        } catch (_: Throwable) {
        }
    }

    private fun collectAttributes(
        provider: ColorAndFontDescriptorsProvider,
        providerName: String,
        descriptors: MutableList<DiscoveredDescriptor>,
        attributePaths: MutableMap<TextAttributesKey, String>,
        seenPaths: MutableSet<String>,
    ) {
        val items = try {
            ColorSettingsUtil.getAllAttributeDescriptors(provider)
        } catch (_: Throwable) {
            return
        }
        for (descriptor in items) {
            try {
                val segments = JsonNames.pathSegments(providerName, descriptor.displayName)
                val path = JsonNames.toPalettePath(segments)
                if (!seenPaths.add(path)) continue
                attributePaths.putIfAbsent(descriptor.key, path)
                descriptors += DiscoveredDescriptor.Attribute(segments, path, descriptor.key)
            } catch (_: Throwable) {
            }
        }
    }

    private fun collectColors(
        provider: ColorAndFontDescriptorsProvider,
        providerName: String,
        descriptors: MutableList<DiscoveredDescriptor>,
        colorPaths: MutableMap<ColorKey, String>,
        seenPaths: MutableSet<String>,
    ) {
        val items = try {
            ColorSettingsUtil.getAllColorDescriptors(provider)
        } catch (_: Throwable) {
            return
        }
        for (descriptor in items) {
            try {
                val segments = JsonNames.pathSegments(providerName, descriptor.displayName)
                val path = JsonNames.toPalettePath(segments)
                if (!seenPaths.add(path)) continue
                colorPaths.putIfAbsent(descriptor.key, path)
                descriptors += DiscoveredDescriptor.Color(segments, path, descriptor.key, descriptor.kind)
            } catch (_: Throwable) {
            }
        }
    }
}
