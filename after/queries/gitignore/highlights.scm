;; extends

;; Header capture (comments starting with ###)
((comment) @header
 (#match? @header "^### "))

;; Section capture (comments starting with ##)
((comment) @section
 (#match? @section "^## "))
