" Highlight directory path and basename separately in quickfix lists.
" Format: path/to/file.ext|lnum col col|text

syntax clear qfFileName

" Directory prefix (up to and including the last path separator)
syn match	qfFileName	"^[^|]*[/\\]"		nextgroup=qfFileBase
" Basename after a directory prefix
syn match	qfFileBase	"[^|/\\]*"		contained nextgroup=qfSeparator1
" Bare filename only (no / or \ before the first |)
syn match	qfFileBase	"^[^|/\\]\+\ze|"		nextgroup=qfSeparator1

hi def link qfFileBase	qfFileName
