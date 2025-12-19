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
