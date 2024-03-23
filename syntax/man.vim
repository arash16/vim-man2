if exists('b:current_syntax')
  finish
endif

" Get the CTRL-H syntax to handle backspaced text
runtime! syntax/ctrlh.vim

syntax case ignore

syntax match manString          /“[^”\n]*”/
syntax match manString          /‘[^’\n]*’/
syntax match manString          /'[^'\n]*'/
syntax match manString          /"[^"\n]*"/
syntax match manString          /<[^>\n]*>/
syntax match manString          /{[^}\n]*}/
syntax match manString          /⟨[^⟩\n]*⟩/
syntax match manString          /<[^⟩\n]*>/
syntax match manNumber          /\v<([+-]?\d+(\.\d+)?(e\d+)?)(\s|,|\.|$)@=/
syntax match manNumber          /\v<([+-]?(0x)(\d|[a-f])+)(\s|,|\.|$)@=q/
hi def link  manNumber          Number

syntax match manReference       '\<\zs\(\f\|:\)\+(\([nlpo]\|\d[a-z]*\)\?)\ze\(\W\|$\)'
syntax match manTitle           '^\(\f\|:\)\+([0-9nlpo][a-z]*).*'
syntax match manSectionHeading  '^[a-z][a-z0-9& ,.-]*[a-z]$'
syntax match manHeaderFile      '\s\zs<\f\+\.h>\ze\(\W\|$\)'
syntax match manURL             `\v<(((https?|ftp|gopher)://|(mailto|file|news):)[^' 	<>"]+|(www|web|w3)[a-z0-9_-]*\.[a-z0-9._-]+\.[^' 	<>"]+)[a-zA-Z0-9/]`
syntax match manEmail           '<\?[a-zA-Z0-9_.+-]\+@[a-zA-Z0-9-]\+\.[a-zA-Z0-9-.]\+>\?'
syntax match manHighlight       +`.\{-}''\?+

syntax match manPageReference   /\v([\/|-]*(IEEE|RFC|ISO|IEC))+(\s|\n)*(std|recommended|[0-9.: -]+)?(\s|\n)*[0-9.: -]*/

syntax match manOptions         '\v[^a-z0-9]\zs-{1,2}[[:alnum:]-_?@%,.+=\S]+\ze'
syntax match manOptions         /\v(^|\s)\%\S+/
syntax match manOptions         /\v^\s+(\w|[!@#$%^&*-])\s{2,}/

syntax match manOptions         /\v^\s+(\S+\s?)+[^.]\s{2,}/
syntax match manOptions         /\v^\s+\w+\=\S+((\s\S+)*((\s{2,})|$))?/
syntax match manOptions         /\v^\s+\w+(,\s?\w+)+q(\s{2,}|$)/

syntax match manVars            /\v((IEEE|RFC|ISO|IEC|\/|-)+)@!<\C[A-Z_][A-Z0-9_*]{3,}/ " UPPER_CASE, but not refs
syntax match manOptions         /\v\C<[a-z0-9]+(_[a-z0-9*]+)+(\s|,|\.|$|$)@=/ " lower_case
syntax match manOptions         /\v<[a-z0-9]{3,}(-[a-z0-9*]{2,}){2,}/ " dash-cased
syntax match manOptions         /\v\s{2,}\S+\s{2,}/
syntax match manOptions         /\v\C<[A-Z][a-z]+([A-Z][a-z]+)+/

syntax match manCommand         /\v^\s+\$\s.*$/

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
hi def link manString          String
hi def link manPageReference   SpecialComment
hi def link manCommand         Tag

let b:current_syntax = 'man'

" vim:set ft=vim et sw=2:
