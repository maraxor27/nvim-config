if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim


" <email@domain>
syn match gitEmail /<[^>]\+>/

" I<hex value>
syn match gitChangeId /I[0-9a-f]\{7,}/
" http[s]:// ...
syn match gitHttp /http[^ ]\+/
" syn match gitEmail /<[a-zA-Z0-9@-\.]+>/
syn match gitCommitHash /[0-9a-f]\{7,}/ 
syn match gitShowTags /\[[a-zA-Z0-9]\+\]/
" syn keyword gitShowLang commit Author Commit Fixed Bug Change-Id Reviewed-on Reviewed-by Commit-Queue Cr-Commit-Position


syn match gitShowLang /\v(Author|Commit|commit|Fixed|Bug|Change-Id|Reviewed-on|Reviewed-by|Commit-Queue|Cr-Commit-Position|Auto-Submit|Drive-by)/

syn match gitShowLang /Commit-Queue/

syn match gitColon /:\ze\s/

syn match gitIssues /\v(v8|chromium):\d{1,}/

hi def link gitIssues Bold
hi def link gitColon Operator
hi def link gitEmail Special
hi def link gitChangeId Special
hi def link gitHttp Underlined
hi def link gitCommitHash String
hi def link gitShowTags Conditional
hi def link gitShowLang Identifier

