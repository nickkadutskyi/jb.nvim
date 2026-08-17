;; extends

; path in require should be an inactive hyperlink
((function_call
  name: (identifier) @_name
  arguments: (arguments
    (string
      content: (string_content)) @string.special.url ))
  (#eq? @_name "require"))


