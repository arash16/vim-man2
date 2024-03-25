if exists('b:current_syntax')
  finish
endif

" Problematic for tests
" ls, date, lsblk, glob(7), man, ed, vi, clang, ld

" documented conventions: man(7)

" TODO: version-numbers, glob patterns, [str], [xx,[22],34,[22]], key=value, .txt
" Phrack Reader: https://github.com/0x4445565A/phrack-reader

" keyword: x86-64

" Get the CTRL-H syntax to handle backspaced text
runtime! syntax/ctrlh.vim

syntax case ignore

syntax match manString          /\v“([^”]|\n)*”/
syntax match manString          /\v‘([^’]|\n)*’/
syntax match manString          /\v`([^`]|\n)*`/
syntax match manString          /\v"([^"]|\n)*"/
syntax match manString          /\v\w@<!'[^'\n]*'/ " doesn't match quote after a word
syntax match manString          /<[^>\n]*>/
syntax match manString          /⟨[^⟩\n]*⟩/
syntax match manString          /{[^}\n]*}/
hi def link manString           String

syntax match manNumber          /\v\W\zs[\+-]?\d+(\.\d+)?(e\d+)?\ze(\W|$)/ " any floating number
syntax match manNumber          /\v\W\zs[\+-]?0x(\d|[a-f])+\ze(\W|$)/ " hex numbers
syntax match manNumber          /\v\W\zs\d+((\.\.|-|:|\/)\d+)+\ze(\W|$)/ " any ranges 1-100 or 1..100
hi def link  manNumber          Number

syntax match manCommand         /\v^\s+\$\s.*$/ " any line starting with $
syntax match manCommand         /\v\W\zs\~?(\/(\w|[-_~*.])+)+\/?/ " any path starting ~/ or /
syntax match manCommand         /\v\W\zs(\w|[-_~*.])+(\/(\w|[-_~*.])+){2,}\/?/ " any path with more than 2 slashes
syntax match manCommand         /\v\W\zs\*(\.\w{,5})+/ " *.xyz

syntax match manReference       '\<\zs\(\f\|:\)\+(\([nlpo]\|\d[a-z]*\)\?)\ze\(\W\|$\)'
syntax match manTitle           '^\(\f\|:\)\+([0-9nlpo][a-z]*).*'
syntax match manSectionHeading  '^[a-z][a-z0-9& ,.-]*[a-z]$'
syntax match manHeaderFile      '\s\zs<\f\+\.h>\ze\(\W\|$\)'
syntax match manURL             `\v<(((https?|ftp|gopher)://|(mailto|file|news):)[^' 	<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' 	<>"]+)[a-zA-Z0-9/]`
syntax match manEmail           '<\?[a-zA-Z0-9_.+-]\+@[a-zA-Z0-9-]\+\.[a-zA-Z0-9-.]\+>\?'
syntax match manHighlight       +`.\{-}''\?+

syntax match manPageReference   /\v([\/|-]*(IEEE|RFC|ISO|IEC))+(\s|\n)*(std|rec|recommended|[0-9.: -]+)?(\s|\n)*[0-9.: -]*/

syntax match manOptions         /\v\W\zs[%+-]{1,2}[^= \t\])]+/ " starting with dash, plus, %
syntax match manOptions         /\v^\s+(\w|[!@#$%^&*-])\s{2,}/ " any single letter followed by 2 spaces

syntax match manVars            /\v\w+\ze\=/ " value=...
syntax match manVars            /\v\$(\w|_)+/ " $variable
syntax match manVars            /\v(\w|_)+(-\>(\w|_)+)+/ " hello->world
syntax match manVars            /\v\C<[a-z0-9_]+(_[a-z0-9_*]+)+[a-z0-9_*(]@!/ " snake_case
syntax match manVars            /\v<[a-z0-9]{3,}(-[a-z0-9*]{2,}){2,}[a-z0-9*(]@!/ " dash-cased
syntax match manVars            /\v\C<[A-Z]?[a-z]+([A-Z][a-z]+)+[[:alnum:]_*(]@!/ " camelCase or PascalCase
syntax match manVars            /\v\n@<!((IEEE|RFC|ISO|IEC|\/|-)+)@!<\C[A-Z_][A-Z0-9_*]{3,}[A-Z0-9_*(]@!/ " UPPER_CASE, but not refs

" below syntax elements valid for manpages 2 & 3 only
if getline(1) =~ '^\(\f\|:\)\+([23][px]\?)'
  syntax include @cCode syntax/c.vim
  syntax match manCFuncDefinition  display '\<\h\w*\>\s*('me=e-1 contained
  syntax match manCError           display '^\s\+\[E\(\u\|\d\)\+\]' contained
  syntax match manSignal           display '\C\<\zs\(SIG\|SIG_\|SA_\)\(\d\|\u\)\+\ze\(\W\|$\)'
  syntax region manSynopsis start='^\(LEGACY \)\?SYNOPSIS'hs=s+8 end='^\u[A-Z ]*$'me=e-30 keepend contains=manSectionHeading,@cCode,manCFuncDefinition,manHeaderFile
  syntax region manErrors   start='^ERRORS'hs=s+6 end='^\u[A-Z ]*$'me=e-30 keepend contains=manSignal,manReference,manSectionHeading,manHeaderFile,manCError
endif

syntax match manFile       display '\s\zs\~\?\/[0-9A-Za-z_*/$.{}<>-]*' contained
syntax match manEnvVarFile display '\s\zs\$[0-9A-Za-z_{}]\+\/[0-9A-Za-z_*/$.{}<>-]*' contained
syntax region manFiles     start='^FILES'hs=s+5 end='^\u[A-Z ]*$'me=e-30 keepend contains=manReference,manSectionHeading,manHeaderFile,manURL,manEmail,manFile,manEnvVarFile,manOptions,manVars,manString,manNumber

syntax match manEnvVar     display '\s\zs\(\u\|_\)\{3,}' contained
syntax region manFiles     start='^ENVIRONMENT'hs=s+11 end='^\u[A-Z ]*$'me=e-30 keepend contains=manReference,manSectionHeading,manHeaderFile,manURL,manEmail,manEnvVar,manOptions,manVars,manString,manNumber

hi def link manTitle           Title
hi def link manSectionHeading  Statement
hi def link manOptionDesc      Constant
hi def link manLongOptionDesc  Constant
hi def link manReference       PreProc
hi def link manCFuncDefinition Function
hi def link manHeaderFile      String
hi def link manURL             Underlined
hi def link manEmail           Underlined
hi def link manCError          Identifier
hi def link manSignal          Identifier
hi def link manFile            Identifier
hi def link manEnvVarFile      Identifier
hi def link manEnvVar          Identifier
hi def link manHighlight       Statement
hi def link manOptions         Constant
hi def link manVars            Identifier
hi def link manPageReference   SpecialComment
hi def link manCommand         Tag

let b:current_syntax = 'man'

" vim:set ft=vim et sw=2:
