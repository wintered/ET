grammar Core;

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
    : 'Bool'
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

b_const
    : 'true'
    | 'false'
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

bool_term
    : b_const 
    | var_name_a
    | var_name_b
    | ParOpen op_not bool_term ParClose
    | ParOpen op_and bool_term bool_term ParClose
    | ParOpen op_or bool_term bool_term ParClose
    | ParOpen op_xor bool_term bool_term ParClose
    | ParOpen op_equals bool_term bool_term ParClose
    | ParOpen op_distinct bool_term bool_term ParClose
    | ParOpen op_ite bool_term bool_term bool_term ParClose
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
