;; extends

; WordPress Block Comments - Inject JSON for attributes {...}
((comment) @injection.content
  (#lua-match? @injection.content "^<!%-%-%s+wp:[%w%-/]+%s+%b{}")
  (#offset-lua-match! @injection.content "%b{}")
  (#set! injection.language "json")
  (#set! injection.include-children))
