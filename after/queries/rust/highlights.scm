;; extends

;; Capture all attributes with the same style
((attribute_item
  "#" @attribute.rust
  "[" @attribute.rust
  (attribute) @attribute.rust
  "]" @attribute.rust) (#set! "priority" 101))

;; Highlight mutable static variables
(static_item
  (mutable_specifier)
  name: (identifier) @variable.mutable_static)

(let_declaration
  (mutable_specifier)
  pattern: (identifier) @variable.mutable_static)

(parameter
  pattern: (identifier) @variable.mutable_static
  type: (reference_type
    (mutable_specifier)))

(type_parameter
  name: (type_identifier) @type.parameter)

(type_arguments
  (type_identifier) @type.parameter)

((lifetime
  (identifier) @type.parameter_lifetime) @type.parameter_lifetime (#set! "priority" 101))
((label
  (identifier) @type.parameter_lifetime) @type.parameter_lifetime (#set! "priority" 101))

([
  (raw_string_literal)
  (string_literal)
] @string (#set! "priority" 101))

((escape_sequence) @string.escape.rust (#set! "priority" 101))

(unsafe_block
  (block
    (expression_statement
      (call_expression
        function: (identifier) @unsafe))))
