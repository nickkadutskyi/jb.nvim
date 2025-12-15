;; extends

; Elevates priorities for everything to override JS highlights when in blade files in script tag

; Increase priority for PHP variables in php_only to override JS highlights
((variable_name) @variable
  (#set! priority 101))

; Elevate other captures to priority 101
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
 ] @punctuation.bracket (#set! priority 101)

[
  (php_tag)
  (php_end_tag)
 ] @tag (#set! priority 101)

; Builtin functions
(function_call_expression
  function: (name) @function.builtin
  (#match? @function.builtin "^(isset|empty|unset|array|list|echo|print|die|exit|eval|include|include_once|require|require_once)$")
  (#set! priority 101))

; $this variable
((variable_name) @variable
  (#eq? @variable "$this")
  (#set! priority 101))

; Named arguments
((argument
  (name) @variable.parameter.named
  ":" @punctuation.delimiter)
  (#set! priority 101))

; Static property access
(scoped_property_access_expression
  scope: (_)
  name: (variable_name) @variable.member.static
  (#set! priority 101))

; Static property declarations
(property_declaration
  (static_modifier)
  (property_element
    (variable_name) @property.static)
  (#set! priority 101))

; Doc comments
((comment) @comment.documentation
  (#match? @comment.documentation "^/\\*\\*")
  (#set! priority 101))

; Constants
(const_declaration
  (const_element
    (name) @constant.only)
  (#set! priority 101))

(namespace_use_clause
  type: "const"
  [
    (name) @constant.only
    (qualified_name
      (name) @constant.only)
    alias: (name) @constant.only
  ]
  (#set! priority 101))

(class_constant_access_expression
  .
  [
    (name)
    (qualified_name
      (name))
  ]
  (name) @constant.only
  (#set! priority 101))

; Injected language fragments (regex)
((string_content) @injected_language_fragment
  (#match? @injected_language_fragment "^[/#~].*[/#~][imsxADSUXu]*$")
  (#set! priority 101))
