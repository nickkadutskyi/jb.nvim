syn keyword apacheFix FIX FIXME BUG FIXIT ISSUE ERROR
syn keyword apacheTodo TODO
syn keyword apacheHack HACK
syn keyword apacheWarn WARN WARNING XXX
syn keyword apachePerf PERF OPTIM PERFORMANCE OPTIMIZE
syn keyword apacheInfo NOTE INFO

syn match apacheComment "^\s*#.*$" contains=apacheFix,apacheTodo,apacheHack,apacheWarn,apachePerf,apacheInfo

hi def link apacheFix @comment.error_Custom
hi def link apacheTodo General_Code_TODODefaults_Default
hi def link apacheHack @comment.warning_Custom
hi def link apacheWarn @comment.warning_Custom
hi def link apachePerf @comment.note_Custom
hi def link apacheInfo @comment.note_Custom
