" stealed from Nikhil Bysani

function! ale_linters#java#arc#Handle(buffer, lines) abort
    let l:output = []

    let l:pattern = '\v(.*):(\d+):(.*)$'


    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'type': 'E',
        \   'lnum': l:match[2],
        \   'text': l:match[3],
        \})
    endfor

    return l:output
endfunction

function! ale_linters#java#arc#GetCommand(buffer) abort
    return 'arc lint --output compiler %s'
endfunction

call ale#linter#Define('java', {
\   'name': 'arc',
\   'executable': 'arc',
\   'command': function('ale_linters#java#arc#GetCommand'),
\   'callback': 'ale_linters#java#arc#Handle',
\   'lint_file': 1,
\})
