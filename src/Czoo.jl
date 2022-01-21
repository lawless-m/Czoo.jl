module Czoo

const LIB="src/libczoo"

export free_ptr, add, concat, cons, CPstring, PString, pstring, ptr_pstring, CLinkedPstring, LinkedPstring, linked_pstrings

"""
    free_ptr(ptr; free=true)  
Free the given ptr if not C_NULL.
# Arguments
- `ptr` the C pointer to be freed
- `free` a conditional flag to prevent an `if` at the call site
"""
free_ptr(ptr; free=true) = if free && ptr != C_NULL ccall(:free, Cvoid, (Ptr{Cvoid},), Ptr{Cvoid}(ptr)) end

"""
    string_from_ptr_uchar(ptr_uchar; free=true)
Create a Julia String from a memory location a byte at a time.
# Arguments
- `ptr_uchar` pointer to use
- `free` flag to determine if the memory should be freed once copied
"""
function string_from_ptr_uchar(ptr_uchar; free=true)
    if ptr_uchar == C_NULL
        return ""
    end
    uchars = Vector{UInt8}()
    i = 1
    while (c = unsafe_load(ptr_uchar, i)) != 0
        push!(uchars, c)
        i += 1
    end
    free_ptr(ptr_uchar; free)
    String(uchars)
end

"""
    vec_string_from_ptr_ptr_uchar(ptr_ptr_uchar; free=true)
Create a Vector{String} from the supplied list of uchar*
# Arguments
- `ptr_ptr_uchar` the pointer to the list
- `free` flag to determine if the memory of both the strings and the list should be freed once copied
"""
function vec_string_from_ptr_ptr_uchar(ptr_ptr_uchar; free=true)
    if ptr_ptr_uchar == C_NULL
        return String[]
    end
    strings = Vector{String}()
    i = 1
    while (stringp = unsafe_load(ptr_ptr_uchar,i)) != C_NULL
        push!(strings, string_from_ptr_uchar(stringp; free))
        i += 1
    end
    free_ptr(ptr_ptr_uchar; free)
    strings
end

"""
    CPstring
A "Pascal" style string with a length and the uchars
# Properties
- `length::Cint` length of the uchars
- `uchars::Ptr{Cuchar}` pointer to the uchars
"""
struct CPstring
    length::Cint
    uchars::Ptr{Cuchar}
end

"""
    Pstring
The Julia version of the `CPstring`
# Properties
- `length::Int` length of the string
- `uchars::String` the string
# Constructor
- `Pstring(cp::CPstring; free=true)` - create a Pstring from a CPstring and optionally free the memory
"""
struct Pstring
    length::Int
    uchars::String
    Pstring(cp::CPstring; free=true) = new(Int(cp.length), string_from_ptr_uchar(cp.uchars; free)) 
    function Pstring(pcp::Ptr{CPstring}; free=true)
        if pcp == C_NULL
            new(0, "")
        else
            cp = unsafe_load(pcp, 1)
            new(Int(cp.length), string_from_ptr_uchar(cp.uchars; free)) 
        end
    end
end

"""
    CLinkedPstring
A "Pascal" style string which also links to the "next" in the list
# Properties
- `next::Ptr{CLinkedPstring}`
- `length::Cint`
- `uchars::Ptr{Cuchar}`
"""
struct CLinkedPstring
    next::Ptr{CLinkedPstring}
    length::Cint
    uchars::Ptr{Cuchar}
end

"""
    LinkedPstring 
The Julia version of the CLinkedPstring
# Constructor
- `LinkedPstring(clp::CLinkedPstring; free=true)` - create a LinkedPstring (following all the links) from a CLinkedPstring and optionally free the memory
- `LinkedPstring(pclp::Ptr{CLinkedPstring}; free=true)` - create a LinkedPstring (following all the links) from a Ptr{CLinkedPstring} and optionally free the memory

"""
struct LinkedPstring 
    next
    length
    uchars
    LinkedPstring(clp::CLinkedPstring; free=true) = new(clp.next == C_NULL ? nothing : LinkedPstring(clp.next), clp.length, string_from_ptr_uchar(clp.uchars; free))
    function LinkedPstring(pclp::Ptr{CLinkedPstring}; free=true)
        if pclp == C_NULL 
            return new(nothing, 0, "")
        end
        lp = LinkedPstring(unsafe_load(pclp,1); free)
        free_ptr(pclp; free)
        lp
    end
end

"""
    add_int(a, b)
Calls C to adds two Ints and returns the result
"""
add_int(a, b) = @ccall LIB.add(a::Int, b::Int)::Int

"""
    concat_string(a, b)
Calls C to concat two Strings and returns the result (and frees the memory)
"""
concat_string(a, b) = (@ccall LIB.concat(a::Cstring, b::Cstring)::Ptr{Cuchar}) |> string_from_ptr_uchar

"""
    cons_string(a, b)
Calls C to create a list of two Strings and returns the result as a Vector{String} (and frees the memory)
"""
cons_string(a, b) = (@ccall LIB.cons(a::Cstring, b::Cstring)::Ptr{Ptr{Cuchar}}) |> vec_string_from_ptr_ptr_uchar

"""
    pstring(a)
Calls C to create a CPstring struct and returns a PString (and frees the memory used for the string)
"""
pstring(a) = Pstring(@ccall LIB.pstring(a::Cstring)::CPstring)

"""
    ptr_pstring(a)
Calls C to create a Ptr{CPstring} struct and returns a PString (and frees the memory of the string and the malloc'd struct)
"""
ptr_pstring(a) = Pstring((@ccall LIB.ptr_pstring(a::Cstring)::Ptr{CPstring}))

"""
    linked_pstrings(a, b, c)
Calls C to create a Ptr{CLinkedPstring} struct and returns a LinkedPString (and frees the memory of the string and the malloc'd structs)
"""
linked_pstrings(a, b, c) = LinkedPstring((@ccall LIB.linked_pstrings(a::Cstring, b::Cstring, c::Cstring)::Ptr{CLinkedPstring}))

end
