# http://python.org
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](py) %{
    set buffer filetype python
}

# Highlighters & Completion
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter -group / regions -default code python \
    double_docstring '"""' '"""'            '' \
    single_docstring "'''" "'''"            '' \
    double_string '"'   (?<!\\)(\\\\)*"  '' \
    single_string "'"   (?<!\\)(\\\\)*'  '' \
    comment       '#'   '$'              '' \
    double_fstring 'f"""' '"""'            '' \
    single_fstring "f'''" "'''"            '' \
    double_fstring 'f"'   (?<!\\)(\\\\)*"  '' \
    single_fstring "f'"   (?<!\\)(\\\\)*'  '' \

add-highlighter -group /python/double_string fill string
add-highlighter -group /python/single_string fill string
add-highlighter -group /python/double_fstring fill string
add-highlighter -group /python/single_fstring fill string
add-highlighter -group /python/double_docstring fill docstring
add-highlighter -group /python/single_docstring fill docstring
add-highlighter -group /python/comment       fill comment

add-highlighter -group /python/double_fstring regions regions interpolation (?<!\{)\{(?!\{) \} \{
add-highlighter -group /python/single_fstring regions regions interpolation (?<!\{)\{(?!\{) \} \{
add-highlighter -group /python/double_fstring/regions/interpolation fill clear
add-highlighter -group /python/single_fstring/regions/interpolation fill clear
add-highlighter -group /python/double_fstring/regions/interpolation ref python/code
add-highlighter -group /python/single_fstring/regions/interpolation ref python/code

%sh{
    # Grammar
    const="True|False|None|\d+"
    meta="import|from"
    # Keyword list is collected using `keyword.kwlist` from `keyword`
    keywords="and|as|assert|break|class|continue|def|del|elif|else|except|exec"
    keywords="${keywords}|finally|for|global|if|lambda|not|or|pass|print"
    keywords="${keywords}|raise|return|try|while|with|yield|in|async"
    operators="\bis\b|[=!<>]=|[|!<>*^+-]"
    types="bool|buffer|bytearray|bytes|complex|dict|file|float|frozenset|int"
    types="${types}|list|long|memoryview|object|set|str|tuple|unicode|xrange"
    types="${types}"
    builtins="abs|all|any|ascii|bin|callable|chr|classmethod|compile|complex"
    builtins="${builtins}|delattr|dict|dir|divmod|enumerate|eval|exec|filter"
    builtins="${builtins}|format|frozenset|getattr|globals|hasattr|hash|help"
    builtins="${builtins}|hex|id|__import__|input|isinstance|issubclass|iter"
    builtins="${builtins}|len|locals|map|max|memoryview|min|next|oct|open|ord"
    builtins="${builtins}|pow|print|property|range|repr|reversed|round"
    builtins="${builtins}|setattr|slice|sorted|staticmethod|sum|super|type|vars|zip"

    # Add the language's grammar to the static completion list
    printf %s\\n "hook global WinSetOption filetype=python %{
        set window static_words '${values}:${meta}:${keywords}:${types}:${builtins}'
    }" | sed 's,|,:,g'

    # Highlight keywords
    printf %s "
        add-highlighter -group /python/code regex '\b(${const})\b' 0:const
        add-highlighter -group /python/code regex '\b(${meta})\b' 0:meta
        add-highlighter -group /python/code regex '${operators}' 0:operator
        add-highlighter -group /python/code regex '\b(${keywords})\b' 0:keyword
        add-highlighter -group /python/code regex '\b(${builtins})\b\(' 1:builtin
        add-highlighter -group /python/code regex '^\s*(def|class)\s+(\w+)' 2:function
    "

    # Highlight types and attributes
    printf %s "
        add-highlighter -group /python/code regex '\b(${types})\b' 0:type
        add-highlighter -group /python/code regex '@[\w_]+\b' 0:attribute
    "
}

# Commands
# ‾‾‾‾‾‾‾‾

def -hidden python-indent-on-new-line %{
    eval -draft -itersel %{
        # copy '#' comment prefix and following white spaces
        try %{ exec -draft k <a-x> s ^\h*#\h* <ret> y jgh P }
        # preserve previous line indent
        try %{ exec -draft \; K <a-&> }
        # cleanup trailing whitespaces from previous line
        try %{ exec -draft k <a-x> s \h+$ <ret> d }
        # indent after line ending with :
        try %{ exec -draft <space> k x <a-k> :$ <ret> j <a-gt> }
    }
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook -group python-highlight global WinSetOption filetype=python %{ add-highlighter ref python }

hook global WinSetOption filetype=python %{
    hook window InsertChar \n -group python-indent python-indent-on-new-line
    # cleanup trailing whitespaces on current line insert end
    hook window InsertEnd .* -group python-indent %{ try %{ exec -draft \; <a-x> s ^\h+$ <ret> d } }
}

hook -group python-highlight global WinSetOption filetype=(?!python).* %{ remove-highlighter python }

hook global WinSetOption filetype=(?!python).* %{
    remove-hooks window python-indent
}
