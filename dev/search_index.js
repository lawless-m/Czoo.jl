var documenterSearchIndex = {"docs":
[{"location":"#Czoo.jl","page":"Czoo.jl","title":"Czoo.jl","text":"","category":"section"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"This project aims to create examples of interfacing Julia code with C-Code","category":"page"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"free_ptr","category":"page"},{"location":"#Czoo.free_ptr","page":"Czoo.jl","title":"Czoo.free_ptr","text":"free_ptr(ptr; free=true)\n\nFree the given C ptr in C.\n\nArguments\n\nptr the C pointer to be freed\nfree a conditional flag to prevent an if at the call site\n\n\n\n\n\n","category":"function"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"add","category":"page"},{"location":"#Czoo.add","page":"Czoo.jl","title":"Czoo.add","text":"add(a, b)\n\nCalls C to adds two Ints and returns the result\n\n\n\n\n\n","category":"function"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"concat","category":"page"},{"location":"#Czoo.concat","page":"Czoo.jl","title":"Czoo.concat","text":"concat(a, b)\n\nCalls C to concat two Strings and returns the result (and frees the memory)\n\n\n\n\n\n","category":"function"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"cons","category":"page"},{"location":"#Czoo.cons","page":"Czoo.jl","title":"Czoo.cons","text":"cons(a, b)\n\nCalls C to create a list of two Strings and returns the result as a Vector{String} (and frees the memory)\n\n\n\n\n\n","category":"function"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"CPstring","category":"page"},{"location":"#Czoo.CPstring","page":"Czoo.jl","title":"Czoo.CPstring","text":"CPstring\n\nA \"Pascal\" style string with a length and the uchars\n\nProperties\n\nlength::Cint length of the uchars\nuchars::Ptr{Cuchar} pointer to the uchars\n\n\n\n\n\n","category":"type"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"Pstring","category":"page"},{"location":"#Czoo.Pstring","page":"Czoo.jl","title":"Czoo.Pstring","text":"Pstring\n\nThe Julia version of the CPstring\n\nProperties\n\nlength::Int length of the string\nuchars::String the string\n\nConstructor\n\nPstring(cp::CPstring; free=true) - create a Pstring from a CPstring and optionally free the memory\n\n\n\n\n\n","category":"type"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"pstring","category":"page"},{"location":"#Czoo.pstring","page":"Czoo.jl","title":"Czoo.pstring","text":"pstring(a)\n\nCalls C to create a CPstring struct and returns a PString (and frees the memory used for the string)\n\n\n\n\n\n","category":"function"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"ptr_pstring","category":"page"},{"location":"#Czoo.ptr_pstring","page":"Czoo.jl","title":"Czoo.ptr_pstring","text":"ptr_pstring(a)\n\nCalls C to create a Ptr{CPstring} struct and returns a PString (and frees the memory of the string and the malloc'd struct)\n\n\n\n\n\n","category":"function"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"CLinkedPstring","category":"page"},{"location":"#Czoo.CLinkedPstring","page":"Czoo.jl","title":"Czoo.CLinkedPstring","text":"CLinkedPstring\n\nA \"Pascal\" style string which also links to the \"next\" in the list\n\nProperties\n\nnext::Ptr{CLinkedPstring}\nlength::Cint\nuchars::Ptr{Cuchar}\n\n\n\n\n\n","category":"type"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"LinkedPstring","category":"page"},{"location":"#Czoo.LinkedPstring","page":"Czoo.jl","title":"Czoo.LinkedPstring","text":"LinkedPstring\n\nThe Julia version of the CLinkedPstring\n\nConstructor\n\nLinkedPstring(clp::CLinkedPstring; free=true) - create a LinkedPstring (following all the links) from a CLinkedPstring and optionally free the memory\nLinkedPstring(pclp::Ptr{CLinkedPstring}; free=true) - create a LinkedPstring (following all the links) from a Ptr{CLinkedPstring} and optionally free the memory\n\n\n\n\n\n","category":"type"},{"location":"","page":"Czoo.jl","title":"Czoo.jl","text":"linked_pstrings","category":"page"},{"location":"#Czoo.linked_pstrings","page":"Czoo.jl","title":"Czoo.linked_pstrings","text":"linked_pstrings(a, b, c)\n\nCalls C to create a Ptr{CLinkedPstring} struct and returns a LinkedPString (and frees the memory of the string and the malloc'd structs)\n\n\n\n\n\n","category":"function"}]
}