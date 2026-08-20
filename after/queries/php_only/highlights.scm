;; extends

;; TODO: tree-sitter-blade uses this for its php parts but it
;;       might fail if Blade embeds php code into <script> tag
;;       becasue php code will be interpreted as javascript
;;       Opened issue to fix this: https://github.com/EmranMR/tree-sitter-blade/issues/136

; php open/close tags are not punctuation but tags
([
  (php_tag)
  (php_end_tag)
] @tag)

; Language constructs, not regular builtin functions
(function_call_expression
  function: (name) @function.builtin
  (#match? @function.builtin "^(isset|empty|unset|array|list|echo|print|die|exit|eval|include|include_once|require|require_once)$"))

; Doc comments
((comment) @comment.documentation
  (#match? @comment.documentation "^/\\*\\*"))

; Named arguments
; TODO: fix this upstream by adjusting a similar query in nvim-treesitter
(argument
  (name) @variable.parameter.name)

; Uppercase variable names like `$_GET` are not constants
; so we need higher priority in such cases for a variable
; TODO: fix this upstream in nvim-treesitter
(variable_name
  (name) @variable
  (#lua-match? @variable "^_?[A-Z][A-Z%d_]*$")
  (#set! priority 101))

; Static property access like SomeClass::$shared
(scoped_property_access_expression
  scope: (_)
  name: (variable_name) @variable.member.static)

; Static property declarations like `public static $shared`
(property_declaration
  (static_modifier)
  (property_element
    (variable_name) @property.static))

; Injected language fragments (regex)
((string_content) @injected_language_fragment
  (#match? @injected_language_fragment "^[/#~].*[/#~][imsxADSUXu]*$")
  (#set! priority 101))

; This is to elevate method over constructor for __constructor method
(method_declaration
  name: (name) @function.method
  (#set! priority 101))

; Ensure that attribute brackets are highlighted as well
(attribute_group
  "#[" @attribute
  (attribute
    (qualified_name
      . "\\" @attribute))?
  "]" @attribute)

; Qualified attribute names take precedence over constant and module captures
(attribute
  (qualified_name) @attribute
  (#set! priority 101))

; TODO: in nvim-treesitter the whole `attribute_list` is highlighted
;       as @attribute which competes with all other highlights inside the attributes

; Directives
; TODO: in upstream it uses @variable.parameter which is wrong
;       it should be a @keyword.directive, so make a PR
(declare_directive
  [
    "strict_types"
    "ticks"
    "encoding"
  ] @keyword.directive)
