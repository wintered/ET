grammar ArraysInts;

ParOpen
    : '('
    ;

ParClose
    : ')'
    ;

var_name_array
    : 'ARRAY_VAR'
    ;

var_name_int
    : 'INT_VAR'
    ;

iconst
    : 'INT_CONST'
    ;

op_select
    : 'select'
    ;

op_store 
    : 'store'
    ;

arr_term 
    : var_name_array
    | ParOpen op_store var_name_array int_term int_term ParClose
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
    | ParOpen op_minus int_term ParClose
    | ParOpen op_minus int_term int_term ParClose
    | ParOpen op_plus int_term int_term ParClose
    | ParOpen op_multiplication int_term int_term ParClose
    | ParOpen op_div int_term int_term ParClose
    | ParOpen op_mod int_term int_term ParClose
    | ParOpen op_abs int_term ParClose
    | ParOpen op_select arr_term int_term ParClose
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
    : ParOpen op_not arr_term ParClose
    | ParOpen op_and arr_term arr_term ParClose
    | ParOpen op_or arr_term arr_term ParClose
    | ParOpen op_xor arr_term arr_term ParClose
    | ParOpen op_equals arr_term arr_term ParClose
    | ParOpen op_distinct arr_term arr_term ParClose
    | ParOpen op_ite arr_term arr_term arr_term ParClose
    ;

integer_comparison
    : ParOpen op_equals int_term int_term ParClose
    | ParOpen op_smaller_equal int_term int_term ParClose
    | ParOpen op_smaller int_term int_term ParClose
    | ParOpen op_greater_equal int_term int_term ParClose
    | ParOpen op_greater int_term int_term ParClose
    ;
    
bool_term
    : array_comparison
    | boolean_operation
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
    : assertStatement checkSat EOF
    ;
