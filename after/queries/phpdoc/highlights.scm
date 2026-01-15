;; extends

(tag
  (tag_name) @attribute
  [
   (named_type) @type.template
   (name) @function.method
   (named_type) @type.phpdoc
   (primitive_type) @keyword.php
   (array_type (primitive_type) @keyword.php)
   (union_type) @type.phpdoc
   (union_type (primitive_type) @keyword.php)
   (union_type (array_type (primitive_type) @keyword.php))
   (array_type) @type.phpdoc
   (variable_name) @variable.member
   (parameters
     (parameter
       (variable_name) @variable.parameter
         (#set! priority 102)
     )
   )
  ]
  (#set! priority 102)
)

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
