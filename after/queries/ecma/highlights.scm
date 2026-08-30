;; extends

; `constructor, this, super` should be keywords
(method_definition
  name: (property_identifier) @keyword
    (#eq? @keyword "constructor"))
[
  (this)
  (super)
] @keyword

; Builtin classes / constructors
; ((identifier) @type
;   (#any-of? @type
;     ; Fundamentals
;     "Object" "Function" "Boolean" "Symbol" "Number" "BigInt" "String"
;     ; Time / text / regex
;     "Date" "RegExp"
;     ; Collections
;     "Array" "Map" "Set" "WeakMap" "WeakSet" "WeakRef"
;     ; Async / meta
;     "Promise" "Proxy" "FinalizationRegistry"
;     ; Binary data
;     "ArrayBuffer" "SharedArrayBuffer" "DataView"
;     "Int8Array" "Uint8Array" "Uint8ClampedArray"
;     "Int16Array" "Uint16Array"
;     "Int32Array" "Uint32Array"
;     "BigInt64Array" "BigUint64Array"
;     "Float16Array" "Float32Array" "Float64Array"
;     ; Errors
;     "Error" "AggregateError" "EvalError" "InternalError"
;     "RangeError" "ReferenceError" "SyntaxError" "TypeError" "URIError"))

; Builtin namespaces (not `new`-able types)
((identifier) @module.builtin
  (#any-of? @module.builtin
    "Math" "JSON" "Intl" "Reflect" "Atomics" "WebAssembly"))
