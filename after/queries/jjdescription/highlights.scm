;; extends

; BREAKING CHANGE / BREAKING-CHANGE footer (Conventional Commits)
((body_line) @punctuation.special.jjdescription
  (#lua-match? @punctuation.special.jjdescription "^BREAKING CHANGE:")
  (#offset-lua-match! @punctuation.special.jjdescription "^BREAKING CHANGE:"))

((body_line) @punctuation.special.jjdescription
  (#lua-match? @punctuation.special.jjdescription "^BREAKING%-CHANGE:")
  (#offset-lua-match! @punctuation.special.jjdescription "^BREAKING%-CHANGE:"))

; Other footers: token + ": " or " #" (git trailer style)
((body_line) @attribute
  (#lua-match? @attribute "^%a[%w%-]*: ")
  (#not-lua-match? @attribute "^BREAKING%-CHANGE:")
  (#offset-lua-match! @attribute "^%a[%w%-]*"))

((body_line) @attribute
  (#lua-match? @attribute "^%a[%w%-]* #")
  (#offset-lua-match! @attribute "^%a[%w%-]*"))
