using Czoo
using Test

@testset "Czoo.jl" begin
    cd("..")
    read(`make src/`)
    if isfile("src/libczoo.so")
        @test free_ptr(C_NULL) == nothing
        @test add(1, 2) == 3
        @test concat("a", "b") == "ab"
        @test cons("a", "b") == ["a", "b"]
        @test pstring("aaz") == Pstring("aaz")
        @test ptr_pstring("zaz") == Pstring("zaz")
        @test isequal(linked_pstrings("a1", "b2", "c3"), LinkedPstring(LinkedPstring(LinkedPstring("c3"), "b2"), "a1"))
        @test print_list_int(Cint[1,2,3]) == 24
        @test print_Pstring_as_Cstring(Pstring("hai")) == 43
    end
end
