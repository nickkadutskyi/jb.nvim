(directive) @tag
(directive_start) @tag
(directive_end) @tag
(comment) @comment
; (parameter) @string
(bracket_start) @punctuation.bracket
(bracket_end) @punctuation.bracket

; (parameter) @none
; (_section_parameter) @string
(parameter) @none
(text) @string

; From https://medium.com/@jogarcia/laravel-blade-on-neovim-ee530ff5d20d
(directive) @function
(directive_start) @function
(directive_end) @function
(comment) @comment
((parameter) @include (#set! "priority" 110))
((php_only) @include (#set! "priority" 110))
((bracket_start) @function (#set! "priority" 120))
((bracket_end) @function (#set! "priority" 120))
(keyword) @function
