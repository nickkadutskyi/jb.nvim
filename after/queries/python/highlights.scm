;; extends

(decorator
  (call
    (identifier) @attribute (#set! "priority" 102)))

; Bytes string
((string
  (string_start) @_start
  (string_content)
  (string_end)) @string.bytes
  (#eq? @_start "b'"))

; Keyword arguments
(call
  arguments: (argument_list
    (keyword_argument
      name: (identifier) @variable.parameter.keyword_argument)))

((call
  function: (identifier) @function.call)
 (#set! "priority" 101))

((class_definition
  body: (block
    (expression_statement
      (assignment
        left: (identifier) @variable.member (#set! "priority" 101)))))
  (#lua-match? @variable.member "^[%l_].*$"))

((class_definition
  body: (block
    (expression_statement
      (assignment
        left: (_
          (identifier) @variable.member (#set! "priority" 101))))))
  (#lua-match? @variable.member "^[%l_].*$"))
