" Vim syntax file
" Language: Type-lang
" Maintainer: Chris Clark
" Latest Revision: January 13 2024

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

let s:ty_syntax_keywords = {
    \   'tyBoolean': ["true"
    \ ,                "false"]
    \ , 'tyVoids': ["void"
    \ ,              "undefined"
    \ ,              "never"]
    \ , 'tyType': ["bool"
    \ ,             "d32"
    \ ,             "d64"
    \ ,             "d128"
    \ ,             "i8"
    \ ,             "i16"
    \ ,             "i32"
    \ ,             "i64"
    \ ,             "usize"
    \ ,             "i8"
    \ ,             "i16"
    \ ,             "i32"
    \ ,             "i64"
    \ ,             "isize"
    \ ,             "f32"
    \ ,             "f64"
    \ ,             "f128"
    \ ,             "type"
    \ ,             "any"
    \ ,             "frame"]
    \ , 'tyConditional': ["if"
    \ ,                    "else"
    \ ,                    "match"]
    \ , 'tyRepeat': ["while"
    \ ,               "for"
    \ ,               "loop"]
    \ , 'tyStructure': ["struct"
    \ ,                  "error"
    \ ,                  "packed"
    \ ,                  "opaque"]
    \ , 'tyVarDecl': ["let"
    \ ,                "const"
    \ ,                "comptime"
    \ ,                "contract"
    \ ,                "local"]
    \ , 'tyDummyVariable': ["_"]
    \ , 'tyKeyword': ["fn"
    \ ,                "try"
    \ ,                "of"
    \ ,                "in"
    \ ,                "test"
    \ ,                "pub"
    \ ,                "import"
    \ ,                "bench"]
    \ , 'tyExecution': ["return"
    \ ,                  "break"
    \ ,                  "continue"]
    \ , 'tyMacro': ["defer"
    \ ,              "errdefer"
    \ ,              "async"
    \ ,              "nosuspend"
    \ ,              "await"
    \ ,              "frame"
    \ ,              "trait"
    \ ,              "impl"
    \ ,              "suspend"
    \ ,              "resume"
    \ ,              "export"
    \ ,              "macro"
    \ ,              "catch"
    \ ,              "extern"]
    \ }

function! s:syntax_keyword(dict)
  for key in keys(a:dict)
    execute 'syntax keyword' key join(a:dict[key], ' ')
  endfor
endfunction

call s:syntax_keyword(s:ty_syntax_keywords)

syntax match tyType "\v<[iu][1-9]\d*>"
syntax match tyOperator display "\V\[#$-+/*=^&?|!><%~]"
syntax match tyArrowCharacter display "\V=>"

"                                     12_34  (. but not ..)? (12_34)?     (exponent  12_34)?
syntax match tyDecNumber display   "\v<\d%(_?\d)*%(\.\.@!)?%(\d%(_?\d)*)?%([eE][+-]?\d%(_?\d)*)?"

syntax match tyCharacterInvalid display contained /b\?'\zs[\n\r\t']\ze'/
syntax match tyCharacterInvalidUnicode display contained /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/
syntax match tyCharacter /b'\([^\\]\|\\\(.\|x\x\{2}\)\)'/ contains=tyEscape,tyEscapeError,tyCharacterInvalid,tyCharacterInvalidUnicode
syntax match tyCharacter /'\([^\\]\|\\\(.\|x\x\{2}\|u\x\{4}\|U\x\{6}\)\)'/ contains=tyEscape,tyEscapeUnicode,tyEscapeError,tyCharacterInvalid

syntax region tyBlock start="{" end="}" transparent fold

syntax region tyCommentLine start="//" end="$" contains=tyTodo,@Spell
syntax region tyCommentLineDoc start="//[/!]/\@!" end="$" contains=tyTodo,@Spell

syntax match tyMultilineStringPrefix /c\?\\\\/ contained containedin=tyMultilineString
syntax region tyMultilineString matchgroup=tyMultilineStringDelimiter start="c\?\\\\" end="$" contains=tyMultilineStringPrefix display

syntax keyword tyTodo contained TODO

syntax region tyString matchgroup=tyStringDelimiter start=+c\?"+ skip=+\\\\\|\\"+ end=+"+ oneline contains=tyEscape,tyEscapeUnicode,tyEscapeError,@Spell
syntax match tyEscapeError   display contained /\\./
syntax match tyEscape        display contained /\\\([nrt\\'"]\|x\x\{2}\)/
syntax match tyEscapeUnicode display contained /\\\(u\x\{4}\|U\x\{6}\)/

highlight default link tyDecNumber tyNumber
highlight default link tyHexNumber tyNumber
highlight default link tyOctNumber tyNumber
highlight default link tyBinNumber tyNumber

highlight default link tyKeyword Keyword
highlight default link tyType Type
highlight default link tyCommentLine Comment
highlight default link tyCommentLineDoc Comment
highlight default link tyDummyVariable Comment
highlight default link tyTodo Todo
highlight default link tyString String
highlight default link tyStringDelimiter String
highlight default link tyMultilineString String
highlight default link tyMultilineStringContent String
highlight default link tyMultilineStringPrefix String
highlight default link tyMultilineStringDelimiter Delimiter
highlight default link tyCharacterInvalid Error
highlight default link tyCharacterInvalidUnicode tyCharacterInvalid
highlight default link tyCharacter Character
highlight default link tyEscape Special
highlight default link tyEscapeUnicode tyEscape
highlight default link tyEscapeError Error
highlight default link tyBoolean Boolean
highlight default link tyNumber Number
highlight default link tyArrowCharacter tyOperator
highlight default link tyOperator Operator
highlight default link tyStructure Structure
highlight default link tyExecution Special
highlight default link tyMacro Macro
highlight default link tyConditional Conditional
highlight default link tyRepeat Repeat

delfunction s:syntax_keyword

let b:current_syntax = "ty"

let &cpo = s:cpo_save
unlet! s:cpo_save
