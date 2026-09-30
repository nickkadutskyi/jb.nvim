;; extends

(interpolation
  (raw_text) @injected_language_fragment)

((tag_name) @tag.custom
  (#any-of? @tag.custom "template" "script"))
