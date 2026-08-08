;; extends

; Elevates priorities for everything to override JS highlights when in blade files in script tag

([
  (php_tag)
  ; TODO: find a way to add this only if nvim-treesitter is from `main` branch
  ; (php_end_tag)
] @tag
  (#set! priority 101))

; Builtin functions
(function_call_expression
  function: (name) @function.builtin
  (#match? @function.builtin "^(isset|empty|unset|array|list|echo|print|die|exit|eval|include|include_once|require|require_once)$")
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

; This is to elevate method over constructor for __constructor method
(method_declaration
  name: (name) @function.method
  (#set! priority 101))

; ; nvim-treesitter php_only highlights elevated to priority 101
; ; (override JS when php_only is injected inside blade <script>)
;
; ; Keywords
; ([
;   "and"
;   "as"
;   "instanceof"
;   "or"
;   "xor"
; ] @keyword.operator
;   (#set! priority 101))
;
; ([
;   "fn"
;   "function"
; ] @keyword.function
;   (#set! priority 101))
;
; ([
;   "clone"
;   "declare"
;   "default"
;   "echo"
;   "enddeclare"
;   "extends"
;   "global"
;   "goto"
;   "implements"
;   "insteadof"
;   "print"
;   "new"
;   "unset"
; ] @keyword
;   (#set! priority 101))
;
; ([
;   "enum"
;   "class"
;   "interface"
;   "namespace"
;   "trait"
; ] @keyword.type
;   (#set! priority 101))
;
; ([
;   "abstract"
;   "const"
;   "final"
;   "private"
;   "protected"
;   "public"
;   "readonly"
;   "static"
; ] @keyword.modifier
;   (#set! priority 101))
;
; ([
;   "return"
;   "exit"
;   "yield"
;   "yield from"
; ] @keyword.return
;   (#set! priority 101))
;
; ([
;   "case"
;   "else"
;   "elseif"
;   "endif"
;   "endswitch"
;   "if"
;   "switch"
;   "match"
;   "??"
; ] @keyword.conditional
;   (#set! priority 101))
;
; ([
;   "break"
;   "continue"
;   "do"
;   "endfor"
;   "endforeach"
;   "endwhile"
;   "for"
;   "foreach"
;   "while"
; ] @keyword.repeat
;   (#set! priority 101))
;
; ([
;   "catch"
;   "finally"
;   "throw"
;   "try"
; ] @keyword.exception
;   (#set! priority 101))
;
; ([
;   "include_once"
;   "include"
;   "require_once"
;   "require"
;   "use"
; ] @keyword.import
;   (#set! priority 101))
;
; ([
;   ","
;   ";"
;   ":"
;   "\\"
; ] @punctuation.delimiter
;   (#set! priority 101))
;
; ([
;   (php_tag)
;   (php_end_tag)
;   "("
;   ")"
;   "["
;   "]"
;   "{"
;   "}"
;   "#["
; ] @punctuation.bracket
;   (#set! priority 101))
;
; ([
;   "="
;   "."
;   "-"
;   "*"
;   "/"
;   "+"
;   "%"
;   "**"
;   "~"
;   "|"
;   "^"
;   "&"
;   "<<"
;   ">>"
;   "<<<"
;   "->"
;   "?->"
;   "=>"
;   "<"
;   "<="
;   ">="
;   ">"
;   "<>"
;   "<=>"
;   "=="
;   "!="
;   "==="
;   "!=="
;   "!"
;   "&&"
;   "||"
;   ".="
;   "-="
;   "+="
;   "*="
;   "/="
;   "%="
;   "**="
;   "&="
;   "|="
;   "^="
;   "<<="
;   ">>="
;   "??="
;   "--"
;   "++"
;   "@"
;   "::"
; ] @operator
;   (#set! priority 101))
;
; ; Variables
; ((variable_name) @variable
;   (#set! priority 101))
;
; ; Constants
; (((name) @constant
;   (#lua-match? @constant "^_?[A-Z][A-Z%d_]*$"))
;   (#set! priority 101))
;
; (((name) @constant.builtin
;   (#lua-match? @constant.builtin "^__[A-Z][A-Z%d_]+__$"))
;   (#set! priority 101))
;
; ((const_declaration
;   (const_element
;     (name) @constant))
;   (#set! priority 101))
;
; ; Types
; ([
;   (primitive_type)
;   (cast_type)
;   (bottom_type)
; ] @type.builtin
;   (#set! priority 101))
;
; ((named_type
;   [
;     (name) @type
;     (qualified_name
;       (name) @type)
;     (relative_name
;       (name) @type)
;   ])
;   (#set! priority 101))
;
; ((named_type
;   (name) @type.builtin
;   (#any-of? @type.builtin "static" "self"))
;   (#set! priority 101))
;
; ((class_declaration
;   name: (name) @type)
;   (#set! priority 101))
;
; ((base_clause
;   [
;     (name) @type
;     (qualified_name
;       (name) @type)
;     (relative_name
;       (name) @type)
;   ])
;   (#set! priority 101))
;
; ((enum_declaration
;   name: (name) @type)
;   (#set! priority 101))
;
; ((interface_declaration
;   name: (name) @type)
;   (#set! priority 101))
;
; ((namespace_use_clause
;   [
;     (name) @type
;     (qualified_name
;       (name) @type)
;     alias: (name) @type.definition
;   ])
;   (#set! priority 101))
;
; ((namespace_use_clause
;   type: "function"
;   [
;     (name) @function
;     (qualified_name
;       (name) @function)
;     alias: (name) @function
;   ])
;   (#set! priority 101))
;
; ((namespace_use_declaration
;   type: "function"
;   body: (namespace_use_group
;     (namespace_use_clause
;       [
;         (name) @function
;         (qualified_name
;           (name) @function)
;         alias: (name) @function
;       ])))
;   (#set! priority 101))
;
; ((namespace_use_clause
;   type: "const"
;   [
;     (name) @constant
;     (qualified_name
;       (name) @constant)
;     alias: (name) @constant
;   ])
;   (#set! priority 101))
;
; ((namespace_use_declaration
;   type: "const"
;   body: (namespace_use_group
;     (namespace_use_clause
;       [
;         (name) @constant
;         (qualified_name
;           (name) @constant)
;         alias: (name) @constant
;       ])))
;   (#set! priority 101))
;
; ((class_interface_clause
;   [
;     (name) @type
;     (qualified_name
;       (name) @type)
;     (relative_name
;       (name) @type)
;   ])
;   (#set! priority 101))
;
; ((scoped_call_expression
;   scope: [
;     (name) @type
;     (qualified_name
;       (name) @type)
;     (relative_name
;       (name) @type)
;   ])
;   (#set! priority 101))
;
; ((class_constant_access_expression
;   .
;   [
;     (name) @type
;     (qualified_name
;       (name) @type)
;     (relative_name
;       (name) @type)
;   ]
;   (name) @constant)
;   (#set! priority 101))
;
; ((scoped_property_access_expression
;   scope: [
;     (name) @type
;     (qualified_name
;       (name) @type)
;     (relative_name
;       (name) @type)
;   ])
;   (#set! priority 101))
;
; ((scoped_property_access_expression
;   name: (variable_name) @variable.member)
;   (#set! priority 101))
;
; ((trait_declaration
;   name: (name) @type)
;   (#set! priority 101))
;
; ((use_declaration
;   (name) @type)
;   (#set! priority 101))
;
; ((binary_expression
;   operator: "instanceof"
;   right: [
;     (name) @type
;     (qualified_name
;       (name) @type)
;     (relative_name
;       (name) @type)
;   ])
;   (#set! priority 101))
;
; ; Functions, methods, constructors
; ((array_creation_expression
;   "array" @function.builtin)
;   (#set! priority 101))
;
; ((list_literal
;   "list" @function.builtin)
;   (#set! priority 101))
;
; ((exit_statement
;   "exit" @function.builtin
;   "(")
;   (#set! priority 101))
;
; ((method_declaration
;   name: (name) @function.method)
;   (#set! priority 101))
;
; ((function_call_expression
;   function: [
;     (name) @function.call
;     (qualified_name
;       (name) @function.call)
;     (relative_name
;       (name) @function.call)
;   ])
;   (#set! priority 101))
;
; ((scoped_call_expression
;   name: (name) @function.call)
;   (#set! priority 101))
;
; ((member_call_expression
;   name: (name) @function.method.call)
;   (#set! priority 101))
;
; ((function_definition
;   name: (name) @function)
;   (#set! priority 101))
;
; ((nullsafe_member_call_expression
;   name: (name) @function.method)
;   (#set! priority 101))
;
; ((use_instead_of_clause
;   (class_constant_access_expression
;     (_)
;     (name) @function.method)
;   (name) @type)
;   (#set! priority 101))
;
; ((use_as_clause
;   (class_constant_access_expression
;     (_)
;     (name) @function.method)*
;   (name) @function.method)
;   (#set! priority 101))
;
; ((method_declaration
;   name: (name) @constructor
;   (#eq? @constructor "__construct"))
;   (#set! priority 101))
;
; ((object_creation_expression
;   [
;     (name) @constructor
;     (qualified_name
;       (name) @constructor)
;     (relative_name
;       (name) @constructor)
;   ])
;   (#set! priority 101))
;
; ; Parameters
; ((variadic_parameter
;   "..." @operator
;   name: (variable_name) @variable.parameter)
;   (#set! priority 101))
;
; ((simple_parameter
;   name: (variable_name) @variable.parameter)
;   (#set! priority 101))
;
; ((argument
;   (name) @variable.parameter)
;   (#set! priority 101))
;
; ; Member
; ((property_element
;   (variable_name) @property)
;   (#set! priority 101))
;
; ((member_access_expression
;   name: (variable_name
;     (name)) @variable.member)
;   (#set! priority 101))
;
; ((member_access_expression
;   name: (name) @variable.member)
;   (#set! priority 101))
;
; ((nullsafe_member_access_expression
;   name: (variable_name
;     (name)) @variable.member)
;   (#set! priority 101))
;
; ((nullsafe_member_access_expression
;   name: (name) @variable.member)
;   (#set! priority 101))
;
; ; Variables
; ((relative_scope) @variable.builtin
;   (#set! priority 101))
;
; (((variable_name) @variable.builtin
;   (#eq? @variable.builtin "$this"))
;   (#set! priority 101))
;
; ; Namespace
; ((namespace_definition
;   name: (namespace_name
;     (name) @module))
;   (#set! priority 101))
;
; ((namespace_name
;   (name) @module)
;   (#set! priority 101))
;
; ((relative_name
;   "namespace" @module.builtin)
;   (#set! priority 101))
;
; ; Attributes
; ((attribute_list) @attribute
;   (#set! priority 101))
;
; ; Conditions ( ? : )
; ((conditional_expression
;   "?" @keyword.conditional.ternary
;   ":" @keyword.conditional.ternary)
;   (#set! priority 101))
;
; ; Directives
; ((declare_directive
;   [
;     "strict_types"
;     "ticks"
;     "encoding"
;   ] @variable.parameter)
;   (#set! priority 101))
;
; ; Basic tokens
; ([
;   (string)
;   (encapsed_string)
;   (heredoc_body)
;   (nowdoc_body)
;   (shell_command_expression) ; backtick operator: `ls -la`
; ] @string
;   (#set! priority 101))
;
; ((escape_sequence) @string.escape
;   (#set! priority 101))
;
; ([
;   (heredoc_start)
;   (heredoc_end)
; ] @label
;   (#set! priority 101))
;
; ((nowdoc
;   "'" @label)
;   (#set! priority 101))
;
; ((boolean) @boolean
;   (#set! priority 101))
;
; ((null) @constant.builtin
;   (#set! priority 101))
;
; ((integer) @number
;   (#set! priority 101))
;
; ((float) @number.float
;   (#set! priority 101))
;
; ((comment) @comment @spell
;   (#set! priority 101))
;
; ((named_label_statement) @label
;   (#set! priority 101))
;
; ((property_hook
;   (name) @label)
;   (#set! priority 101))
;
; ((visibility_modifier
;   (operation) @label)
;   (#set! priority 101))
