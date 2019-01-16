#pragma once

#include <string>
#include <vector>
#include <iostream>

#define FUNCTION_TYPES(o)\
        o(nop) o(print) o(assign)\
        o(_if) o(_while)

#define o(n) n,
 enum class F_type{FUNCTION_TYPES(o)};
#undef o

    
struct expression_struct
{
    std::string variable="";
    int value;
    std::string operation;
    expression_struct(){}
    expression_struct(const int& val):value(val), variable(){}
    expression_struct(std::string variable_): variable(variable_){}
};
struct function
{
    F_type  ftype{};
    std::vector<expression_struct> ex_vec;
    std::string variable;

    function(){}

    function(F_type ftype_,std::vector<expression_struct> ex_vec_, std::string variable_=""):
        ftype(ftype_),ex_vec(ex_vec_),variable(variable_){}
};
