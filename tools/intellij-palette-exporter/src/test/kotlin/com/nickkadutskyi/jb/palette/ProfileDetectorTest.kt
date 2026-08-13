package com.nickkadutskyi.jb.palette

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class ProfileDetectorTest {
    @Test
    fun lightWithoutColorBlindness() {
        assertEquals(PROFILE_LIGHT, ProfileDetector.detect(false, false))
    }

    @Test
    fun darkWithoutColorBlindness() {
        assertEquals(PROFILE_DARK, ProfileDetector.detect(true, false))
    }

    @Test
    fun lightWithColorBlindness() {
        assertEquals(PROFILE_LIGHT_CB, ProfileDetector.detect(false, true))
    }

    @Test
    fun darkWithColorBlindness() {
        assertEquals(PROFILE_DARK_CB, ProfileDetector.detect(true, true))
    }

    @Test
    fun whiteIsLight() {
        assertFalse(ProfileDetector.isDarkBackground(255, 255, 255))
    }

    @Test
    fun nearBlackIsDark() {
        assertTrue(ProfileDetector.isDarkBackground(25, 26, 28))
    }

    @Test
    fun islandsLightBackgroundIsLight() {
        assertFalse(ProfileDetector.isDarkBackground(0xFF, 0xFF, 0xFE))
    }

    @Test
    fun islandsDarkBackgroundIsDark() {
        assertTrue(ProfileDetector.isDarkBackground(0x19, 0x1A, 0x1C))
    }
}
