;; extends
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "#["
] @punctuation.bracket
[
  (php_tag)
  "?>"
] @tag

; Adds builtin functions to the function scope
(function_call_expression
  function: (name) @function.builtin
  (#match? @function.builtin "^(isset|empty|unset|array|list|echo|print|die|exit|eval|include|include_once|require|require_once)$"))

; Sets `$this` as a @variable to prioritize over @variable.builtin
((variable_name) @variable
  (#eq? @variable "$this"))

; Add specific capture for named arguments
((argument
  (name) @variable.parameter.named
  ":" @punctuation.delimiter))

; For static property access like SomeClass::$shared
(scoped_property_access_expression
  scope: (_)
  name: (variable_name) @variable.member.static)

; For static property declarations like public static $shared
(property_declaration
  (static_modifier)
  (property_element
    (variable_name) @property.static))

; Capture doc comments (/** ... */)
((comment) @comment.documentation
  (#match? @comment.documentation "^/\\*\\*"))

; Redefined @constant to avoid matching `_GET` part in `$_GET` as a constant
; and fixes `Type::A()` where `A` is captured as a constant
((name) @constant.only
  (#lua-match? @constant.only "^_?[A-Z][A-Z%d_]*$")
  (#not-has-parent? @constant.only variable_name scoped_call_expression))

(const_declaration
  (const_element
    (name) @constant.only))

(namespace_use_clause
  type: "const"
  [
    (name) @constant.only
    (qualified_name
      (name) @constant.only)
    alias: (name) @constant.only
  ])

(class_constant_access_expression
  .
  [
    (name)
    (qualified_name
      (name))
  ]
  (name) @constant.only)

; statements that follow a text_interpolation
((program
    (text_interpolation)
    (_)*                                  ; anything
    [ (statement) (expression)
      (primary_expression) (type)
      (literal) (php_tag) ] @template_language))

; statements that precede a text_interpolation
((program
    [ (statement) (expression)
      (primary_expression) (type)
      (literal) (php_tag) ] @template_language
    (_)*
    (text_interpolation)))

(text_interpolation (php_tag) @template_language)

[ "?>" ] @template_language

; attribute name
((attribute
    (qualified_name) @attribute.name)
 (#set! @attribute.name "priority" 110))

; attribute delimiter
((attribute_group
    "#[" @attribute.bracket
    "]"  @attribute.bracket)
 (#set! @attribute.bracket "priority" 110))
