;; extends

(comment
(using_directive
  (using_directive_key) @directive.key
  (using_directive_value) @directive.value
  ) @directive.command (#set! "priority" 101)
) @directive.prefix

(escape_sequence) @string.escape

(type_parameters
name: (identifier) @type.parameter
)

(function_definition
return_type: (type_identifier) @type.parameter
)

(type_definition
name: (type_identifier) @type.parameter
)

(call_expression
  function: (field_expression
    field: (identifier) @function.method.call (#set! "priority" 101)))

(postfix_expression
   (operator_identifier) @tag.xml
   (identifier) @tag.xml
   (#set! "priority" 101)
)
(postfix_expression
   (operator_identifier) @tag.xml (#set! "priority" 101)
)
(infix_expression
   operator: (operator_identifier) @tag.xml
   (#set! "priority" 101)
)

(template_body
 (val_definition
  pattern: (identifier) @template.val))

(given_definition
name: (identifier) @given.name
)

; ((annotation) @attribute (#set! "priority" 101))
(annotation
   name: (type_identifier) @attribute (#set! "priority" 101))

(simple_enum_case
name: (identifier) @enum.single_case
)

