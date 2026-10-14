module JuliaIntro
using Markdown

export forward, backward

const PRESENTATION = []

include("repl-content.jl")


"""
    Collection for content
"""
mutable struct Cursor
    content::Vector{Any}
    pos::Int
end


"""
    next!(cursor::Cursor)

Step forward
"""
function next!(cursor::Cursor)
    cursor.pos += 1
    if cursor.pos > length(cursor.content)
        cursor.pos = 1
    end
    current = cursor.content[cursor.pos]
    if applicable(current)
        current()
    else
        return current
    end    
end


const PC = Cursor(PRESENTATION, 0)
forward() = next!(PC)

"""
    hello(who::String)

Return "Hello, `who`".
"""
hello(who::String) = "Hello, $who"

"""
    domath(x::Number)

Return `x + 5`.
"""
domath(x::Number) = x + 5

end # module JuliaIntro
