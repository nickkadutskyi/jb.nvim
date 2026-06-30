;; extends
; opening parenthesis
; ((bracket_start) @tag
;   (#match? @tag "^\\($")        ; node text is exactly "("
;   (#set! priority 110))         ; higher than 101 → overrides @tag.delimiter

; closing parenthesis
; ((bracket_end) @tag
;   (#match? @tag "^\\)$")        ; node text is exactly ")"
;   (#set! priority 110))

[
  (directive)
  (directive_start)
  (directive_end)
] @directive
