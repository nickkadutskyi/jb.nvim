;; extends

(interpolation
  (raw_text) @injected_language_fragment)

; Vue SFC root blocks
((document
  (script_element
    (start_tag
      (tag_name) @vue.root_tag)
    (end_tag
      (tag_name) @vue.root_tag)))
  (#set! @vue.root_tag priority 130))

((document
  (template_element
    (start_tag
      (tag_name) @vue.root_tag)
    (end_tag
      (tag_name) @vue.root_tag)))
  (#set! @vue.root_tag priority 130))

((document
  (style_element
    (start_tag
      (tag_name) @vue.root_tag)
    (end_tag
      (tag_name) @vue.root_tag)))
  (#set! @vue.root_tag priority 130))
