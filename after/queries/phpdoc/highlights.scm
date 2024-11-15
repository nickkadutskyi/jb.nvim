;; extends

; For template type parameters
(tag
  (tag_name) @_tag
  (#eq? @_tag "@template")
  (named_type) @type.template)

; For method declarations in PHPDoc
(tag
  (tag_name) @_tag
  (#eq? @_tag "@method")
  (name) @function.method)
