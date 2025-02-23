grammar Ints;

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
    : 'Int'
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

int_term
    : iconst 
    | var_name_a
    | var_name_b
    | ParOpen op_minus int_term ParClose
    | ParOpen op_minus int_term int_term ParClose
    | ParOpen op_plus int_term int_term ParClose
    | ParOpen op_multiplication int_term int_term ParClose
    | ParOpen op_div int_term int_term ParClose
    | ParOpen op_mod int_term int_term ParClose
    | ParOpen op_abs int_term ParClose
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
    | ParOpen op_equals int_term int_term ParClose
    | ParOpen op_smaller int_term int_term ParClose
    | ParOpen op_greater int_term int_term ParClose
    | ParOpen op_greater_equal int_term int_term ParClose
    | ParOpen op_smaller_equal int_term int_term ParClose
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
