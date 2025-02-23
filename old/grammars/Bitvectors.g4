grammar Bitvectors;

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
    : '(_ BitVec 64)'
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

bv_const
   : '#x0000000000000000'
   | '#x1111111111111111'
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
    | var_name_a 
    | var_name_b 
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
    : '0' 
    | '1'
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
    : declareConsta declareConstb assertStatement checkSat EOF
    ;
