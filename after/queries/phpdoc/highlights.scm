;; extends

; (tag
;   (tag_name) @attribute
;   [
;    (named_type) @type.template
;    (name) @function.method
;    (named_type) @type.phpdoc
;    (primitive_type) @keyword.php
;    (array_type (primitive_type) @keyword.php)
;    (union_type) @type.phpdoc
;    (union_type (primitive_type) @keyword.php)
;    (union_type (array_type (primitive_type) @keyword.php))
;    (array_type) @type.phpdoc
;    (variable_name) @variable.member
;    (parameters
;      (parameter
;        (variable_name) @variable.parameter
;          (#set! priority 102)
;      )
;    )
;   ]
;   (#set! priority 102)
; )

; WordPress Pattern File Header Keys
; See: https://developer.wordpress.org/themes/patterns/registering-patterns/#registering-patterns-in-theme
((text) @attribute
  (#match? @attribute "^(Title|Slug|Categories|Description|Viewport Width|Inserter|Keywords|Block Types|Post Types|Template Types):")
  (#offset-lua-match! @attribute "^[^:]+:"))

; WordPress Plugin Header Keys
; See: https://developer.wordpress.org/plugins/plugin-basics/header-requirements/
((text) @attribute
  (#match? @attribute "^(Plugin Name|Plugin URI|Description|Version|Requires at least|Requires PHP|Author|Author URI|License|License URI|Text Domain|Domain Path|Network|Update URI|Requires Plugins):")
  (#offset-lua-match! @attribute "^[^:]+:"))

; (description
;   (text) @comment.documentation
;   (#set! priority 125))

; Highlights methods in doc
(tag
  (tag_name) @_tag_name
  (name) @function.method
  (parameters)
  (#eq? @_tag_name "@method"))

; TODO: fix upstream because they have queries that make `|` and `$` a @keyword
;       while it should be @operator and @variable respectively
(array_type
  value: (named_type
    (name) @keyword)
  (#eq? @keyword "static"))

(union_type
  "|" @operator)

(tag
  (tag_name) @_tag
  (#eq? @_tag "@param")
  (variable_name
   "$" @variable.parameter
  ) @variable.parameter)

(tag
  (tag_name) @_tag
  (#eq? @_tag "@property")
  (variable_name
   "$" @variable.member
  ) @variable.member)

(tag
  (tag_name) @_tag
  (#eq? @_tag "@var")
  (variable_name
   "$" @variable.member
  ) @variable)

(parameter
  (variable_name
   "$" @variable.parameter
  ) @variable.parameter)

; Capture each non-description child separately: capturing the whole tag would
; make the nested description both @nospell and @spell.
(tag
  [
    (tag_name)
    (array_type)
    (author_name)
    (disjunctive_normal_form_type)
    (email_address)
    (fqsen)
    (generic_type)
    (intersection_type)
    (name)
    (named_type)
    (optional_type)
    (parameters)
    (primitive_type)
    (static)
    (union_type)
    (uri)
    (variable_name)
    (version)
  ] @nospell)
