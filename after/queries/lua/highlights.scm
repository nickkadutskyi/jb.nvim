;; extends

; path in require should be an inactive hyperlink
((function_call
  name: (identifier) @_name
  arguments: (arguments
    (string
      content: (string_content)) @string.special.url ))
  (#eq? @_name "require"))

; highlighting variable declarations differently, currently LSP doesn't do this well
((variable_declaration
    (variable_list
      name: (identifier) @custom.typemod.variable.declaration))
  (#not-has-ancestor? @custom.typemod.variable.declaration assignment_statement))



