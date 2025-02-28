" Clear previous syntax
syntax clear

" Define keywords
syntax keyword logicKeyword in
syntax match logicKeyword /∀/
syntax match logicKeyword /@\w\+/
highlight link logicKeyword Keyword

" Highlight functions
syntax match logicFunction /#\w\+\((\)\@=/
syntax match logicFunction /#\w\+\s*\((\)\@!/
highlight link logicFunction Function

" Comments
syntax match myComment /\/\/.*/
highlight link myComment Comment

" Function call - fixed to not include the opening parenthesis
syntax match logicFunctionCall /\w\+\ze(/
highlight link logicFunctionCall Function
