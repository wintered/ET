grammar MixedIntReal;

ParOpen
    : '('
    ;

ParClose
    : ')'
    ;

var_name_int
    : 'INT_VAR'
    ;

var_name_real
    : 'REAL_VAR'
    ;

rconst
    : 'REAL_CONST' 
    ;

iconst
    : 'INT_CONST'
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
    | var_name_int
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
    | var_name_real
    | ParOpen op_minus real_term ParClose
    | ParOpen op_minus real_term real_term ParClose
    | ParOpen op_plus real_term real_term ParClose
    | ParOpen op_multiplication real_term real_term ParClose
    | ParOpen op_division real_term real_term ParClose
    | ParOpen op_sin real_term ParClose
    | ParOpen op_cos real_term ParClose
    | ParOpen op_tan real_term ParClose
    | ParOpen op_toreal int_term ParClose
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

bool_term
    : ParOpen op_not bool_term ParClose
    | ParOpen op_and bool_term bool_term ParClose
    | ParOpen op_or bool_term bool_term ParClose
    | ParOpen op_xor bool_term bool_term ParClose
    | ParOpen op_equals bool_term bool_term ParClose
    | ParOpen op_distinct bool_term bool_term ParClose
    | ParOpen op_ite bool_term bool_term bool_term ParClose
    | ParOpen op_equals real_term real_term ParClose
    | ParOpen op_smaller real_term real_term ParClose
    | ParOpen op_greater real_term real_term ParClose
    | ParOpen op_greater_equal real_term real_term ParClose
    | ParOpen op_smaller_equal real_term real_term ParClose
    | ParOpen op_equals int_term int_term ParClose
    | ParOpen op_smaller_equal int_term int_term ParClose
    | ParOpen op_smaller int_term int_term ParClose
    | ParOpen op_greater_equal int_term int_term ParClose
    | ParOpen op_greater int_term int_term ParClose
    | ParOpen op_isint real_term ParClose
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
