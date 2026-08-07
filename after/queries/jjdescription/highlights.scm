;; extends

; BREAKING CHANGE / BREAKING-CHANGE footer (Conventional Commits)
((body_line) @punctuation.special
  (#lua-match? @punctuation.special "^BREAKING CHANGE:")
  (#offset-lua-match! @punctuation.special "^BREAKING CHANGE:"))

((body_line) @punctuation.special
  (#lua-match? @punctuation.special "^BREAKING CHANGE #")
  (#offset-lua-match! @punctuation.special "^BREAKING CHANGE #"))

((body_line) @punctuation.special
  (#lua-match? @punctuation.special "^BREAKING%-CHANGE:")
  (#offset-lua-match! @punctuation.special "^BREAKING%-CHANGE:"))

((body_line) @punctuation.special
  (#lua-match? @punctuation.special "^BREAKING%-CHANGE #")
  (#offset-lua-match! @punctuation.special "^BREAKING%-CHANGE #"))

; Other footers: token + ": " or " #" (git trailer style)
((body_line) @attribute
  (#lua-match? @attribute "^%a[%w%-]*: ")
  (#not-lua-match? @attribute "^BREAKING%-CHANGE:")
  (#offset-lua-match! @attribute "^%a[%w%-]*"))

((body_line) @attribute
  (#lua-match? @attribute "^%a[%w%-]* #")
  (#not-lua-match? @attribute "^BREAKING%-CHANGE #")
  (#offset-lua-match! @attribute "^%a[%w%-]*"))
