;; extends

; Exported variables
(export_statement
  (lexical_declaration
    (variable_declarator
      name: (identifier) @variable.exported)))

(export_statement
  (function_declaration
      name: (identifier) @function.exported))

(import_statement
  (import_clause
    (identifier) @variable.exported))

(import_statement
  (import_clause
    (named_imports
      (import_specifier
        name: (identifier) @variable.exported)
      )))
