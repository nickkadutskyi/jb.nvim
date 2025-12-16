;; extends

; Extend regex highlighting for PHP string literals that look like regex patterns
((string_content) @injection.content
  (#match? @injection.content "^[/#~].*[/#~][imsxADSUXu]*$")
  (#set! injection.language "regex"))

; /* */-style Comments
((comment) @injection.language
  . ; this is to make sure only adjacent comments are accounted for the injections
  [
    (string
      (string_content) @injection.content)
    (encapsed_string
      (string_content) @injection.content)
  ]
  (#gsub! @injection.language "/%*%s*([%w%p]+)%s*%*/" "%1")
  (#set! injection.combined))

; //-style Comments
((comment) @injection.language
  . ; this is to make sure only adjacent comments are accounted for the injections
  [
    (string
      (string_content) @injection.content)
    (encapsed_string
      (string_content) @injection.content)
  ]
  (#gsub! @injection.language "//%s*([%w%p]+)%s*" "%1")
  (#set! injection.combined))

