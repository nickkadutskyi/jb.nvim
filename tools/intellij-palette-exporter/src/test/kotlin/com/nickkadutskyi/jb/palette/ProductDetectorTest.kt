package com.nickkadutskyi.jb.palette

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class ProductDetectorTest {
    @Test
    fun mapsIntelliJCodes() {
        assertEquals(PRODUCT_INTELLIJ, ProductDetector.from("IU"))
        assertEquals(PRODUCT_INTELLIJ, ProductDetector.from("IC"))
        assertEquals(PRODUCT_INTELLIJ, ProductDetector.from("iu"))
    }

    @Test
    fun mapsOtherIdes() {
        assertEquals("Rider", ProductDetector.from("RD"))
        assertEquals("CLion", ProductDetector.from("CL"))
        assertEquals("WebStorm", ProductDetector.from("WS"))
        assertEquals("PhpStorm", ProductDetector.from("PS"))
    }

    @Test
    fun fallsBackToProductName() {
        assertEquals(PRODUCT_INTELLIJ, ProductDetector.from("", "IntelliJ IDEA"))
        assertEquals("CLion", ProductDetector.from("", "CLion"))
    }

    @Test
    fun unknownCodeWithoutNameDefaultsToIntelliJ() {
        assertEquals(PRODUCT_INTELLIJ, ProductDetector.from(""))
    }

    @Test
    fun canonicalCheck() {
        assertTrue(ProductDetector.isCanonical(PRODUCT_INTELLIJ))
        assertFalse(ProductDetector.isCanonical("Rider"))
    }
}
