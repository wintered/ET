grammar Strings;

ParOpen
    : '('
    ;

ParClose
    : ')'
    ;

var_name_a
    : 'a'
    ;

var_name_b 
    : 'b'
    ;

var_type
    : 'String'
    ;

cmd_declare_const 
    : 'declare-const'
    ;

declareConsta
    : ParOpen cmd_declare_const var_name_a var_type ParClose
    ;

declareConstb
    : ParOpen cmd_declare_const var_name_b var_type ParClose
    ;

iconst
    : '0'
    | '1'
    ;

op_to_int
    : 'str_to_int'
    ;

op_index_of
    : 'str.indexof'
    ;


sconst 
    : '""'
    | '"a"'
    ;

op_str_plusplus
    :'str.++'
    ;
    
op_str_at
    : 'str.at'
    ;

op_substr
    : 'str.substr'
    ;

op_replace
    :'str.replace'
    ;

op_replace_all
    :'str.replace_all'
    ;

op_from_int
    : 'str.from_int'
    ;

str_term
    : sconst 
    | var_name_a 
    | var_name_b
    | ParOpen op_str_plusplus str_term str_term ParClose
    | ParOpen op_str_at str_term integer_term ParClose
    | ParOpen op_substr str_term integer_term integer_term ParClose
    | ParOpen op_replace str_term str_term str_term ParClose
    | ParOpen op_replace_all str_term str_term str_term ParClose
    | ParOpen op_from_int integer_term ParClose
    ;

integer_term
    : iconst 
    | ParOpen op_to_int str_term ParClose
    | ParOpen op_index_of str_term str_term integer_term ParClose
    ;


regex_const
    : 're.none'
    | 're.all'
    | 're.allchar'
    ;

op_re_comp
    : 're.comp'
    ;

op_re_plus 
    : 're.+'
    ;

op_re_opt
    : 're.opt'
    ;

op_re_union
    : 're.union'
    ;

op_re_inter
    : 're.inter'
    ;

op_re_plusplus
    : 're.++'
    ;

op_re_diff
    : 're.diff'
    ;

op_re_star
    : 're.star'
    ;

op_str_to_re
    : 'str.to_re'
    ;

op_range
    : 're.range'
    ;

regex_term
    : regex_const
    | ParOpen op_re_comp regex_term ParClose
    | ParOpen op_re_plus regex_term ParClose
    | ParOpen op_re_opt regex_term ParClose
    | ParOpen op_re_union regex_term regex_term ParClose
    | ParOpen op_re_inter regex_term regex_term ParClose
    | ParOpen op_re_plusplus regex_term regex_term ParClose
    | ParOpen op_re_diff regex_term regex_term ParClose
    | ParOpen op_re_star regex_const ParClose
    | ParOpen op_str_to_re str_term ParClose
    | ParOpen op_range str_term str_term ParClose
    ;

op_not 
    : 'not'
    ;

op_and
    : 'and'
    ;

op_or 
    : 'or'
    ;

op_xor
    : 'xor'
    ;

op_equals
    : '='
    ;

op_distinct
    : '='
    ;

op_ite
    : 'ite'
    ;

op_str_leq
    : 'str.<='
    ;

op_prefixof
    : 'str.prefixof'
    ;

op_suffixof
    : 'str.suffixof'
    ;

op_contains
    : 'str.contains'
    ;

op_is_digit
    : 'str.is_digit'
    ;

op_str_in_re
    : 'str.in_re'
    ;

bool_term
    : ParOpen op_not bool_term ParClose
    | ParOpen op_and bool_term bool_term ParClose
    | ParOpen op_or bool_term bool_term ParClose
    | ParOpen op_xor bool_term bool_term ParClose
    | ParOpen op_equals bool_term bool_term ParClose
    | ParOpen op_distinct bool_term bool_term ParClose
    | ParOpen op_ite bool_term bool_term bool_term ParClose
    | ParOpen op_equals str_term str_term ParClose
    | ParOpen op_distinct str_term str_term ParClose
    | ParOpen op_str_leq str_term str_term ParClose
    | ParOpen op_prefixof str_term str_term ParClose
    | ParOpen op_suffixof str_term str_term ParClose
    | ParOpen op_contains str_term str_term ParClose
    | ParOpen op_is_digit str_term ParClose
    | ParOpen op_str_in_re str_term regex_term ParClose
    ;

cmd_checkSat
    : 'check-sat'
    ;

checkSat
    : ParOpen cmd_checkSat ParClose
    ;

cmd_assert
    : 'assert'
    ;

assertStatement
    : ParOpen cmd_assert bool_term ParClose
    ;

start
    : declareConsta declareConstb assertStatement checkSat EOF
    ;
