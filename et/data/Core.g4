grammar Core;

ParOpen
    : '('
    ;

ParClose
    : ')'
    ;

var_name
    : 'VAR'
    ;

var_type
    : 'Bool'
    ;

b_const
    : 'CONST'
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
    | var_name
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
    : assertStatement checkSat EOF
    ;
