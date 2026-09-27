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

; Vue component imports in Vue SFCs
((import_statement
  (import_clause
    (identifier) @type)
  source: (string) @_source)
  (#vue-file?)
  (#lua-match? @_source "%.vue['\"]$")
  (#set! @type priority 130))

; Vue composable imports
((import_statement
  (import_clause
    (identifier) @function.call))
  (#vue-file?)
  (#lua-match? @function.call "^use[A-Z]")
  (#set! @function.call priority 130))

((import_statement
  (import_clause
    (named_imports
      (import_specifier
        name: (identifier) @function.call))))
  (#vue-file?)
  (#lua-match? @function.call "^use[A-Z]")
  (#set! @function.call priority 130))
