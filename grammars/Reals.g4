grammar Reals;

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
    : 'Real'
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

rconst
    : '0.0' 
    | '1.0'
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

op_division   
    : '/'
    ;

op_mod     
    : 'mod'
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

real_term
    : rconst 
    | var_name_a
    | var_name_b
    | ParOpen op_minus real_term ParClose
    | ParOpen op_minus real_term real_term ParClose
    | ParOpen op_plus real_term real_term ParClose
    | ParOpen op_multiplication real_term real_term ParClose
    | ParOpen op_division real_term real_term ParClose
    | ParOpen op_sin real_term ParClose
    | ParOpen op_cos real_term ParClose
    | ParOpen op_tan real_term ParClose
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
