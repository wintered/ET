grammar Arrays;

ParOpen
    : '('
    ;

ParClose
    : ')'
    ;

var_name_array
    : 'ARRAY_VAR'
    ;

var_name_bitvec
    : 'BITVEC64_VAR'
    ;

bv_const
   : 'BITVEC64_CONST'
   ;

op_bvneg
    : 'bvneg'
    ;

op_bvor
    : 'bvor'
    ;

op_bvadd
    : 'bvadd'
    ;

op_select
    : 'select'
    ;

bitvec_term 
    : bv_const
    | var_name_bitvec
    | ParOpen op_bvneg bitvec_term ParClose
    | ParOpen op_bvor bitvec_term bitvec_term ParClose
    | ParOpen op_bvadd bitvec_term bitvec_term ParClose
    | ParOpen op_select arr_term bitvec_term ParClose
    ;

op_store 
    : 'store'
    ;

arr_term 
    : var_name_array
    | ParOpen op_store var_name_array bitvec_term bitvec_term ParClose
    ;

op_equals
    : '='
    ;

op_distinct
    : 'distinct'
    ;

bool_term
    : ParOpen op_equals arr_term arr_term ParClose
    | ParOpen op_distinct arr_term arr_term ParClose
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
