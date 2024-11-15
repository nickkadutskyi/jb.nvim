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
  scope: (_) @type
  name: (variable_name) @variable.member.static)

; For static property declarations like public static $shared
(property_declaration
  (static_modifier)
  (property_element
    (variable_name) @property.static))

; Capture doc comments (/** ... */)
((comment) @comment.documentation
  (#match? @comment.documentation "^/\\*\\*"))
