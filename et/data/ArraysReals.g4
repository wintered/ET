grammar ArraysReals;

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

var_type_a_int
    : 'Int'
    ;

var_type_b_arr
    : '(Array Int Real)'
    ;

cmd_declare_const 
    : 'declare-const'
    ;

declareConsta
    : ParOpen cmd_declare_const var_name_a var_type_a_int ParClose
    ;

declareConstb
    : ParOpen cmd_declare_const var_name_b var_type_b_arr ParClose
    ;

iconst
    : '0'
    | '1'
    ;

rconst
    : '0.0' 
    | '1.0'
    ;

op_select
    : 'select'
    ;

op_store 
    : 'store'
    ;

arr_term 
    : var_name_b
    | ParOpen op_store var_name_b int_term real_term ParClose
    ;

op_minus 
    : '-'
    ;

op_plus 
    : '+' 
    ;

op_multiplication
    : '*'
    ;  

op_div   
    : 'div'
    ;

op_mod     
    : 'mod'
    ;

op_abs
    : 'abs'
    ;

op_toint
    : 'to_int'
    ;

int_term
    : iconst 
    | var_name_a
    | ParOpen op_minus int_term ParClose
    | ParOpen op_minus int_term int_term ParClose
    | ParOpen op_plus int_term int_term ParClose
    | ParOpen op_multiplication int_term int_term ParClose
    | ParOpen op_div int_term int_term ParClose
    | ParOpen op_mod int_term int_term ParClose
    | ParOpen op_abs int_term ParClose
    | ParOpen op_toint real_term ParClose
    ;

op_division
    : '/'
    ;

op_sin
    : 'sin'
    ;

op_cos
    : 'cos'
    ;

op_tan
    : 'tan'
    ;

op_toreal
    : 'to_real'
    ;

real_term
    : rconst
    | ParOpen op_minus real_term ParClose
    | ParOpen op_minus real_term real_term ParClose
    | ParOpen op_plus real_term real_term ParClose
    | ParOpen op_multiplication real_term real_term ParClose
    | ParOpen op_division real_term real_term ParClose
    | ParOpen op_sin real_term ParClose
    | ParOpen op_cos real_term ParClose
    | ParOpen op_tan real_term ParClose
    | ParOpen op_toreal int_term ParClose
    | ParOpen op_select arr_term int_term ParClose
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
    : 'distinct'
    ;

op_ite
    : 'ite'
    ;

op_smaller_equal
    : '<='
    ;

op_greater_equal
    : '>='
    ;

op_smaller
    : '<'
    ;

op_greater
    : '>' 
    ;

op_isint
    : 'is_int'
    ;

array_comparison
    : ParOpen op_equals arr_term arr_term ParClose
    | ParOpen op_distinct arr_term arr_term ParClose
    ;

boolean_operation
    : ParOpen op_not bool_term ParClose
    | ParOpen op_and bool_term bool_term ParClose
    | ParOpen op_or bool_term bool_term ParClose
    | ParOpen op_xor bool_term bool_term ParClose
    | ParOpen op_equals bool_term bool_term ParClose
    | ParOpen op_distinct bool_term bool_term ParClose
    | ParOpen op_ite bool_term bool_term bool_term ParClose
    ;

real_comparison
    : ParOpen op_equals real_term real_term ParClose
    | ParOpen op_smaller real_term real_term ParClose
    | ParOpen op_greater real_term real_term ParClose
    | ParOpen op_greater_equal real_term real_term ParClose
    | ParOpen op_smaller_equal real_term real_term ParClose
    ;

integer_comparison
    : ParOpen op_equals int_term int_term ParClose
    | ParOpen op_smaller_equal int_term int_term ParClose
    | ParOpen op_smaller int_term int_term ParClose
    | ParOpen op_greater_equal int_term int_term ParClose
    | ParOpen op_greater int_term int_term ParClose
    ;

real_property
    : ParOpen op_isint real_term ParClose
    ;

bool_term
    : array_comparison
    | boolean_operation
    | real_comparison
    | integer_comparison
    | real_property
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
