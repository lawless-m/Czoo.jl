module Czoo

const LIB="src/libczoo"

export free_ptr, add, concat, cons, CPstring, Pstring, pstring, ptr_pstring, CLinkedPstring, LinkedPstring, linked_pstrings
export print_list_int, print_Pstruct, Pstruct, print_Pstring_as_Cstring, capture_c_stdout_to_file, capture_c_stdout_to_IOBuffer

"""
    free_ptr(ptr; free=true)  
Free the given C ptr in C.
# Arguments
- `ptr` the C pointer to be freed
- `free` a conditional flag to prevent an `if` at the call site
"""
free_ptr(ptr; free=true) = if free ccall(:free, Cvoid, (Ptr{Cvoid},), Ptr{Cvoid}(ptr)) end

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
    Pstring(s::String) = new(length(s), s)
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
    LinkedPstring(s::AbstractString) = new(nothing, length(s), s)
    LinkedPstring(lp, s::AbstractString) = new(lp, length(s), s)
end

Base.isequal(lp1::LinkedPstring, lp2::LinkedPstring) = isequal(lp1.next, lp2.next) && lp1.length == lp2.length && lp1.uchars == lp2.uchars

"""
    add(a, b)
Calls C to adds two Ints and returns the result
"""
add(a, b) = @ccall LIB.add(a::Int, b::Int)::Int

"""
    concat(a, b)
Calls C to concat two Strings and returns the result (and frees the memory)
"""
concat(a, b) = (@ccall LIB.concat(a::Cstring, b::Cstring)::Ptr{Cuchar}) |> string_from_ptr_uchar

"""
    cons(a, b)
Calls C to create a list of two Strings and returns the result as a Vector{String} (and frees the memory)
"""
cons(a, b) = (@ccall LIB.cons(a::Cstring, b::Cstring)::Ptr{Ptr{Cuchar}}) |> vec_string_from_ptr_ptr_uchar

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


"""
    print_list_ints(ints::Vector{Cint})
Calls C to print a list of Ints
"""
print_list_int(ints::Vector{Cint}) = @ccall LIB.print_list_int(ints::Ptr{Cint}, length(ints)::Cint)::Cint

"""
    print_Pstring_as_Cstring(ps::Pstring)
Send a Pstring Julia struct as a converted Cstring struct. I imagine there is a way to do this without the conversion.
"""
function print_Pstring_as_Cstring(ps::Pstring)
    cp = CPstring(ps.length, pointer(ps.uchars))
    @ccall LIB.print_Pstring(cp::CPstring)::Cint 
end

"""
    capture_c_stdout_to_file()
Redirect stdout of the C program to a file and print it in Julia. 
"""
function capture_c_stdout_to_file(c::Cint)
    (path, io) = mktemp() # Julia will delete this on exit
    prev_stdout = stdout
    redirect_stdout(io) do
        ccall(:putchar, Cint, (Cint,), c)
        Base.Libc.flush_cstdio() # required or it sits in the buffer - even between invocations
    end
    seekstart(io)
    redirect_stdout(prev_stdout)
    captured = "Captured: $(String(read(io)))"
    println(captured)
    captured
end

"""
    capture_c_stdout_to_IOBuffer(c::Cint)
Call a C function and capture its stdout into an IOBuffer
Thanks to Carsten Bauer https://github.com/carstenbauer for this one
"""
function capture_c_stdout_to_IOBuffer(c::Cint)

    function call()
        ccall(:putchar, Cint, (Cint,), c)
        Base.Libc.flush_cstdio() # required or it sits in the buffer - even between invocations
        flush(stdout) # also needed 
    end

    io = IOBuffer()
    prev_stdout = stdout
    rd, = redirect_stdout() 
    task = @async write(io, rd)
    try 
        call()
    finally
        close(rd)
        redirect_stdout(prev_stdout)
        wait(task)
    end

    seekstart(io)
    captured = "Captured: $(String(read(io)))"
    println(captured)
    captured
end


#== 
for adding to the collection

puts(s::Union{String,SubString{String}}) = ccall(:puts, Cint, (Ptr{Cchar},), s)
jl_malloc(n::Integer) = ccall(:jl_malloc, Ptr{Cvoid}, (Csize_t,), n)

==#

#== These don't work yet / are untested

"""
    arity0_func()
A function without arguments or return type to send to C to call
"""
arity0_func() = println("J: Airty0 function")

"""
    send_arity0_func()
Create a pointer to a Julia function which takes no arguments and returns nothing.
Call a function C which will, in turn, call that Julia function.
"""
function send_arity0_func()
    jfunc = @cfunction(arity0_func, Ptr{Cvoid}, (Cvoid,))
    @ccall LIB.call_arity0_julia_func(jfunc::Ptr{Cvoid})::Ptr{Cvoid}
end

"""
    airity1_func(i::Cint)
An airity1 function for C to call with a C Int, it just prints it.
"""
airity1_func(i::Cint) = prinlnt("J: C called with $i")

"""
    send_airity1_int(i::Cint)
Create a pointer to a Julia function which takes a C Integer but returns nothing.
Call a function C which will, in turn, call that Julia function.
"""
function send_airity1_int(i::Cint)
    jfunc = @cfunction(airity1_func, Cvoid, (Cvoid,))
    @ccall LIB.call_airity1_julia_func(jfunc::Ptr{Cvoid})::Ptr{Cvoid}
end

"""
    airity2_func(a::Cint, b::Cint)::Cint
Call this function with two Cint arguments and get a Cint in return
"""
    airity2_func(a::Cint, b::Cint)::Cint = begin println("J: called with $a $b, returning $(a+b)"); a+b; end

"""
    send_airity2_func()
"""
function send_airity2_func()
    jfunc = @cfunction(airity2_func, Cint, (Cint, Cint))
    i = @ccall LIB.call_airity2_julia_func(jfunc::Ptr{Cvoid})::Cint
    println("J: Called C, got back $i")
end

==#


###
end
