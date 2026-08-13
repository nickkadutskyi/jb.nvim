package com.nickkadutskyi.jb.palette

object PaletteJson {
    fun parse(text: String): JsonValue = Parser(text).parse()

    fun stringify(value: JsonValue): String {
        val out = StringBuilder()
        write(value, out, 0)
        out.append('\n')
        return out.toString()
    }

    fun emptyDocument(): JsonValue.Obj = JsonValue.Obj()

    private fun write(value: JsonValue, out: StringBuilder, indent: Int) {
        when (value) {
            JsonValue.Null -> out.append("null")
            is JsonValue.Bool -> out.append(value.value)
            is JsonValue.Num -> out.append(value.literal)
            is JsonValue.Str -> writeString(value.value, out)
            is JsonValue.Arr -> writeArray(value, out, indent)
            is JsonValue.Obj -> writeObject(value, out, indent)
        }
    }

    private fun writeObject(obj: JsonValue.Obj, out: StringBuilder, indent: Int) {
        if (obj.entries.isEmpty()) {
            out.append("{}")
            return
        }
        out.append("{\n")
        val keys = sortedKeys(obj.entries.keys)
        keys.forEachIndexed { index, key ->
            indent(out, indent + 1)
            writeString(key, out)
            out.append(": ")
            write(obj.entries.getValue(key), out, indent + 1)
            if (index < keys.lastIndex) out.append(',')
            out.append('\n')
        }
        indent(out, indent)
        out.append('}')
    }

    private fun writeArray(arr: JsonValue.Arr, out: StringBuilder, indent: Int) {
        if (arr.items.isEmpty()) {
            out.append("[]")
            return
        }
        out.append("[\n")
        arr.items.forEachIndexed { index, item ->
            indent(out, indent + 1)
            write(item, out, indent + 1)
            if (index < arr.items.lastIndex) out.append(',')
            out.append('\n')
        }
        indent(out, indent)
        out.append(']')
    }

    internal fun sortedKeys(keys: Collection<String>): List<String> {
        return keys.sortedWith { a, b ->
            val aProfile = PROFILE_KEYS.indexOf(a)
            val bProfile = PROFILE_KEYS.indexOf(b)
            val aStyle = STYLE_KEYS.indexOf(a)
            val bStyle = STYLE_KEYS.indexOf(b)
            when {
                aProfile >= 0 && bProfile >= 0 -> aProfile.compareTo(bProfile)
                aProfile >= 0 -> 1
                bProfile >= 0 -> -1
                aStyle >= 0 && bStyle >= 0 -> aStyle.compareTo(bStyle)
                aStyle >= 0 -> -1
                bStyle >= 0 -> 1
                else -> a.compareTo(b)
            }
        }
    }

    private fun indent(out: StringBuilder, level: Int) {
        repeat(level) { out.append("  ") }
    }

    private fun writeString(value: String, out: StringBuilder) {
        out.append('"')
        for (ch in value) {
            when (ch) {
                '\\' -> out.append("\\\\")
                '"' -> out.append("\\\"")
                '\n' -> out.append("\\n")
                '\r' -> out.append("\\r")
                '\t' -> out.append("\\t")
                else -> if (ch < ' ') {
                    out.append("\\u%04x".format(ch.code))
                } else {
                    out.append(ch)
                }
            }
        }
        out.append('"')
    }

    private class Parser(private val text: String) {
        private var i = 0

        fun parse(): JsonValue {
            skipWs()
            val value = readValue()
            skipWs()
            if (i < text.length) error("Unexpected trailing content at $i")
            return value
        }

        private fun readValue(): JsonValue {
            skipWs()
            if (i >= text.length) error("Unexpected end of JSON")
            return when (val ch = text[i]) {
                '{' -> readObject()
                '[' -> readArray()
                '"' -> JsonValue.Str(readString())
                't' -> readLiteral("true", JsonValue.Bool(true))
                'f' -> readLiteral("false", JsonValue.Bool(false))
                'n' -> readLiteral("null", JsonValue.Null)
                '-', in '0'..'9' -> readNumber()
                else -> error("Unexpected character '$ch' at $i")
            }
        }

        private fun readObject(): JsonValue.Obj {
            i++
            val obj = JsonValue.Obj()
            skipWs()
            if (consume('}')) return obj
            while (true) {
                skipWs()
                val key = readString()
                skipWs()
                expect(':')
                obj[key] = readValue()
                skipWs()
                if (consume('}')) return obj
                expect(',')
            }
        }

        private fun readArray(): JsonValue.Arr {
            i++
            val arr = JsonValue.Arr()
            skipWs()
            if (consume(']')) return arr
            while (true) {
                arr.items.add(readValue())
                skipWs()
                if (consume(']')) return arr
                expect(',')
            }
        }

        private fun readString(): String {
            expect('"')
            val out = StringBuilder()
            while (i < text.length) {
                when (val ch = text[i++]) {
                    '"' -> return out.toString()
                    '\\' -> {
                        if (i >= text.length) error("Unterminated escape")
                        when (val esc = text[i++]) {
                            '"', '\\', '/' -> out.append(esc)
                            'b' -> out.append('\b')
                            'f' -> out.append('\u000C')
                            'n' -> out.append('\n')
                            'r' -> out.append('\r')
                            't' -> out.append('\t')
                            'u' -> {
                                if (i + 4 > text.length) error("Invalid unicode escape")
                                val hex = text.substring(i, i + 4)
                                out.append(hex.toInt(16).toChar())
                                i += 4
                            }
                            else -> error("Invalid escape '\\$esc'")
                        }
                    }
                    else -> out.append(ch)
                }
            }
            error("Unterminated string")
        }

        private fun readNumber(): JsonValue.Num {
            val start = i
            if (text[i] == '-') i++
            while (i < text.length && text[i].isDigit()) i++
            if (i < text.length && text[i] == '.') {
                i++
                while (i < text.length && text[i].isDigit()) i++
            }
            if (i < text.length && (text[i] == 'e' || text[i] == 'E')) {
                i++
                if (i < text.length && (text[i] == '+' || text[i] == '-')) i++
                while (i < text.length && text[i].isDigit()) i++
            }
            return JsonValue.Num(text.substring(start, i))
        }

        private fun readLiteral(expected: String, value: JsonValue): JsonValue {
            if (!text.startsWith(expected, i)) error("Expected $expected at $i")
            i += expected.length
            return value
        }

        private fun skipWs() {
            while (i < text.length && text[i].isWhitespace()) i++
        }

        private fun consume(ch: Char): Boolean {
            if (i < text.length && text[i] == ch) {
                i++
                return true
            }
            return false
        }

        private fun expect(ch: Char) {
            if (!consume(ch)) error("Expected '$ch' at $i")
        }
    }
}
