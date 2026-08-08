;; extends

; <script> bodies are opaque raw_text in tree-sitter-blade (HTML inheritance),
; so {{ }}, {!! !!}, and @php are not php_statement nodes. Re-parse the body as
; blade so those constructs become php_only (via blade's existing injections).
; JS injection from html_tags still applies; raise php_only capture priority to win.
((script_element
  (raw_text) @injection.content)
  (#set! injection.language "blade"))
