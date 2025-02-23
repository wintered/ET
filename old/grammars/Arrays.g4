grammar BitvectorArrays;

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

var_type_arr
    : '(Array (_ BitVec 64) (_ BitVec 64))'
    ;

var_type_bv
    : '(_ BitVec 64)'
    ;

cmd_declare_const 
    : 'declare-const'
    ;

declareConsta
    : ParOpen cmd_declare_const var_name_a var_type_arr ParClose
    ;

declareConstb
    : ParOpen cmd_declare_const var_name_b var_type_bv ParClose
    ;

bv_const
   : '#x0000000000000000'
   | '#x1111111111111111'
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
    | var_name_b
    | ParOpen op_bvneg bitvec_term ParClose
    | ParOpen op_bvor bitvec_term bitvec_term ParClose
    | ParOpen op_bvadd bitvec_term bitvec_term ParClose
    | ParOpen op_select arr_term bitvec_term ParClose
    ;

op_store 
    : 'store'
    ;

arr_term 
    : var_name_a
    | ParOpen op_store var_name_a bitvec_term bitvec_term ParClose
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
    : declareConsta declareConstb assertStatement checkSat EOF
    ;
