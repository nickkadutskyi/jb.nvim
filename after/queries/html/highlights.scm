;; extends

; WordPress Block Comments - Opening blocks
; Highlight the block name (wp:blockname) as @keyword.directive
((comment) @attribute
  (#lua-match? @attribute "^<!%-%-%s+wp:[%w%-/]+")
  (#offset-lua-match! @attribute "wp:[%w%-/]+"))

; WordPress Block Comments - JSON attributes
; Highlight the JSON part {...} as @string (or could use @markup.raw, @property, etc.)
((comment) @string
  (#lua-match? @string "^<!%-%-%s+wp:[%w%-/]+%s+%b{}")
  (#offset-lua-match! @string "%b{}"))

; WordPress Block Comments - Closing blocks
; Highlight the closing block name (/wp:blockname) as @keyword.directive
((comment) @attribute
  (#lua-match? @attribute "^<!%-%-%s+/wp:[%w%-/]+")
  (#offset-lua-match! @attribute "/wp:[%w%-/]+"))

