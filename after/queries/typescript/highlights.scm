;; extends

; Exported variables
(export_statement
  (lexical_declaration
    (variable_declarator
      name: (identifier) @variable.exported)))

(export_statement
  (function_declaration
      name: (identifier) @function.exported))
