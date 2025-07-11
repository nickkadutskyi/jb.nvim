;; extends

(type_parameter
  (type_identifier) @type.parameter)

(constructor_declaration
  name: (identifier) @constructor.declaration (#set! "priority" 130))

((identifier) @constant
  (#lua-match? @constant "^[A-Z_][A-Z%d_]+$")
  (#set! "priority" 130))

(annotation
  "@" @attribute
  name: (identifier) @attribute (#set! "priority" 130))
