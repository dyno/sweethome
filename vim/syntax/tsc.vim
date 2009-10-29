" Vim syn file
" Language:		Ora*Tst Test Script (*.tsc) 
" Maintainer:		Dyno Fu <dyno.fu@oracle.com>
" Last Change:		Jan 04, 2006
" Version:		01

"most test scripts treat themself casesitive 
"althou the grammar is not per the doc
syn case match
syntax sync fromstart
"======================================================================
"builtin 
"keywords which is part of a construct cannot be listed here
"e.g. if, loop, echo, etc 
syn keyword tscBuiltin cleanout reinit exit
syn keyword tscBuiltin import export getglobal
syn keyword tscBuiltin include runtest run runremote
syn keyword tscBuiltin execute runutl
syn keyword tscBuiltin remotelookfor remoterun remotefindfile
syn keyword tscBuiltin fork isactive sleep stop wait
syn keyword tscBuiltin getarea getbasename getfiletype osddirname osdfilename
syn keyword tscBuiltin findfile finddir findstr
syn keyword tscBuiltin mkdir rmdir cpfile mvfile rmfile filter sortfile getfile putfile
syn keyword tscBuiltin decr incr
syn keyword tscBuiltin post until
syn keyword tscBuiltin ldiff 
syn keyword tscBuiltin instance
syn keyword tscBuiltin strcat substr
syn keyword tscBuiltin setarea setdefarea setdeftype setfiletype
syn keyword tscBuiltin report result resultclear resultstore
syn keyword tscBuiltin word words
syn keyword tscBuiltin defmacro
hi link tscBuiltin Keyword

syn keyword tscStandardMacro clonedb compare compile get init sql save
syn keyword tscStandardMacro tkstart
syn keyword tscStandardMacro setdefarea
syn keyword tscStandardMacro rdbmsini restore inst startup shutdown 
syn keyword tscStandardMacro dbdel tablespace 
syn keyword tscStandardMacro execsql sesql
syn keyword tscStandardMacro event markevent popevent
"hi link tscStandardMacro Function 
hi link tscStandardMacro Type

syn keyword tscStandardArea T_WORK T_SRC T_SOURCE T_SYSTEM T_LOG T_SOSD T_DATA 
syn keyword tscStandardArea T_DBS T_HIST
hi link tscStandardArea Constant

syn keyword tscStandardOption NOMASK MASK CASE NOCASE shared nonshared exclusive none normal
hi link tscStandardOption Constant

syn keyword tscBoolean true false TRUE FALSE yes no YES NO y n Y N
hi link tscBoolean Boolean

"======================================================================
"clusters
syn cluster tscElement contains=tscBuiltin,tscStandardMacro,tscStandardArea,tscStandardOption,tscBoolean,tscJump,tscDeref,tscOperator,tscRedirOperator,tscParenthesis
syn cluster tscPart contains=tscAssignment,tscLet,tscString
syn cluster tscBlock contains=tscIf,tscLoop,tscEchoSimple,tscEchoComplex,tscComment,tscRedirect,@tscPart,@tscElement

"======================================================================
"parse syntax contruct
 
"TODO: digit

"comment
syn keyword tscTodo contained NAME FUNCTION DESCRIPTION NOTES MODIFIED RUNS_STANDALONE TEST_TYPE REQUIRES
hi link tscTodo Todo
syn match tscComment /#.*/ contains=tscTodo
hi link tscComment Comment
syn match tscNumberSign /'#/
hi link tscNumbersign String

"variable TODO: hilight ^^temp^ consistently
syn match  tscDeref  /\(\w*\(\^\{1,2}\)\h\w*\2\)\+\w*/ 
hi link tscDeref PreProc
"hi link tscDeref Ignore

"operator
syn match tscOperator /[!+*=-]\|\<AND\>\|\<OR\>\|\<and\>\|\<or\>/
hi link tscOperator Operator
syn match tscRedirOperator /[<>]/
hi link tscRedirOperator Operator
syn match tscParenthesis /(\|)/
hi link tscParenthesis Operator

"quote string
syn match tscQuote /\\\@<!'/ contained
hi link tscQuote Operator
"TODO: which char to escape?
syn match tscString /'\([^']*\(\\'\)\)*[^']*'/ contains=tscDeref,tscQuote 
hi link tscString String

"assignment --startup parameter, etc
syn match tscAssignment /\h\w*=\([^ =]\)\@=/ contains=tscOperator,tscString
hi link tscAssignment Identifier

"let clause
syn region tscLet matchgroup=tscBuiltin start=/\<\(set\|unset\|let\|unlet\)\>/ matchgroup=Identifier end=/\h\w*/

"if 
syn keyword tscConditional contained else 
hi link tscConditional Conditional 
syn region tscIf matchgroup=Conditional start=/\<if\>/ matchgroup=Conditional end=/\<endif\>/ contains=@tscBlock,tscConditional   
"colon-if
syn region tscConlonIf matchgroup=Label start=/\s*\S\+:/ matchgroup=Conditional end=/\<endif\>/ contains=@tscBlock

"echo one-line 
syn region tscEchoSimple matchgroup=tscBuiltin start=/^\s*\<echo\>/ end=/$/ contains=tscDeref,tscComment,tscNumberSign,tscString
hi link tscEchoSimple String
"echo multiline
syn match tscRedirect /^\s*>.*$/ contains=tscRedirOperator,tscDeref
hi link tscRedirect String
syn region tscEchoComplex matchgroup=tscBuiltin start=/^\s*\<echo\>\s*>/ matchgroup=tscBuiltin end=/^\s*\<endecho\>/ contains=@tscBlock,tscRedirOperator

"loop, for 
syn keyword tscJump contained break continue
hi link tscJump Repeat
syn region tscLoop matchgroup=Repeat start=/\<loop\>\|\<for\>/ matchgroup=Repeat end=/\<endloop\>/ contains=@tscBlock 

"TODO:multiline continuation
"======================================================================
