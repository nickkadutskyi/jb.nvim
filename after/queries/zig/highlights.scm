;; extends

(call_expression
  function: (field_expression
    member: (identifier) @function.call)
  (#set! "priority" 135))

(field_expression
  (_)
  member: (identifier) @variable.member
  (#set! "priority" 125))

; ((identifier) @type
;   (#lua-match? @type "^[A-Z_][a-zA-Z0-9_]*")
;   (#set! "priority" 140))
