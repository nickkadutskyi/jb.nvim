;; extends
; Highlight the entire recipe node for background styling
(recipe) @recipe
(recipe_line) @recipe_line
(shell_text) @recipe_line
(shell_command) @recipe_line
(prerequisites) @prerequisites

(shell_function
  [
    "$"
    "("
    ")"
  ] @function.builtin
  "shell" @function.builtin)

(function_call
  [
    "$"
    "("
    ")"
  ] @function.builtin)

