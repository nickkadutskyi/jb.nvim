;; extends
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "#["
] @punctuation.bracket
[
  (php_tag)
  "?>"
] @tag

; Adds builtin functions to the function scope
(function_call_expression
  function: (name) @function.builtin
  (#match? @function.builtin "^(isset|empty|unset|array|list|echo|print|die|exit|eval|include|include_once|require|require_once)$"))
