;; extends

; Extend regex highlighting for PHP string literals that look like regex patterns
((string_content) @injection.content
  (#match? @injection.content "^[/#~].*[/#~][imsxADSUXu]*$")
  (#set! injection.language "regex"))
