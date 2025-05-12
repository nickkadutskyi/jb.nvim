((text) @injection.content
    (#not-has-ancestor? @injection.content "envoy")
    (#set! injection.combined)
    (#set! injection.language php))

((comment) @injection.content
 (#set! injection.language "comment"))

((text) @injection.content
    (#has-ancestor? @injection.content "envoy")
    (#set! injection.combined)
    (#set! injection.language bash))

((php_only) @injection.content
    (#set! injection.language php))

; Inject PHP into directive parameters except for string literals
((parameter) @injection.content
    (#not-has-ancestor? @injection.content "inlineSection")
    (#not-has-ancestor? @injection.content "section")
    (#set! injection.language php))

; From https://medium.com/@jogarcia/laravel-blade-on-neovim-ee530ff5d20d
((text) @injection.content
    (#not-has-ancestor? @injection.content "envoy")
    (#set! injection.combined)
    (#set! injection.language php))
