grammar Bitvectors;

ParOpen
    : '('
    ;

ParClose
    : ')'
    ;

var_name_bitvec
    : 'BITVEC64_VAR'
    ;

bv_const
   : 'BITVEC64_CONST'
   ;


op_bvnot
    : 'bvnot'
    ;

op_bvneg
    : 'bvneg'
    ;

op_bvand 
    : 'bvand'
    ; 

op_bvor 
    : 'bvor'
    ;

op_bvadd
    : 'bvadd'
    ;

op_bvmul
    : 'bvmul'
    ;

op_bvudiv 
    : 'bvudiv'
    ;

op_bvurem
    : 'bvurem'
    ;

op_bvshl 
    : 'bvshl'
    ;

op_bvlshr
    : 'bvlshr'
    ;

bitvec_term 
    : bv_const
    | var_name_bitvec 
    | ParOpen op_bvnot bitvec_term ParClose
    | ParOpen op_bvneg bitvec_term ParClose
    | ParOpen op_bvand bitvec_term bitvec_term ParClose
    | ParOpen op_bvor bitvec_term bitvec_term ParClose
    | ParOpen op_bvadd bitvec_term bitvec_term ParClose
    | ParOpen op_bvmul bitvec_term bitvec_term ParClose
    | ParOpen op_bvudiv bitvec_term bitvec_term ParClose
    | ParOpen op_bvurem bitvec_term bitvec_term ParClose
    | ParOpen op_bvshl bitvec_term bitvec_term ParClose
    | ParOpen op_bvlshr bitvec_term bitvec_term ParClose
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

op_bvult
    : 'bvult'
    ;

bool_term
    : ParOpen op_not bool_term ParClose
    | ParOpen op_and bool_term bool_term ParClose
    | ParOpen op_or bool_term bool_term ParClose
    | ParOpen op_xor bool_term bool_term ParClose
    | ParOpen op_equals bool_term bool_term ParClose
    | ParOpen op_distinct bool_term bool_term ParClose
    | ParOpen op_ite bool_term bool_term bool_term ParClose
    | ParOpen op_bvult bitvec_term bitvec_term ParClose
    | ParOpen op_equals bitvec_term bitvec_term ParClose
    | ParOpen op_distinct bitvec_term bitvec_term ParClose
    | ParOpen op_equals int_term int_term ParClose
    | ParOpen op_distinct int_term int_term ParClose
    ;

op_bv2nat
    : 'bv2nat'
    ;

int_const
    : 'INT_CONST' 
    ;

int_term 
    : int_const 
    | ParOpen op_bv2nat bitvec_term ParClose
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
