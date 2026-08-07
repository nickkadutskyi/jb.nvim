;; extends

; BREAKING CHANGE / BREAKING-CHANGE footer with " #" (not parsed by grammar)
((message_line) @punctuation.special
  (#lua-match? @punctuation.special "^BREAKING CHANGE #")
  (#offset-lua-match! @punctuation.special "^BREAKING CHANGE #"))

((message_line) @punctuation.special
  (#lua-match? @punctuation.special "^BREAKING%-CHANGE #")
  (#offset-lua-match! @punctuation.special "^BREAKING%-CHANGE #"))

; Other footers: token + " #" (git trailer style, not parsed by grammar)
((message_line) @label
  (#lua-match? @label "^%a[%w%-]* #")
  (#not-lua-match? @label "^BREAKING%-CHANGE #")
  (#offset-lua-match! @label "^%a[%w%-]*"))
