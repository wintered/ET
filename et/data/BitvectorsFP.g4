grammar BitvectorsFP;

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

var_type_bit
    : '(_ BitVec 64)'
    ;

var_type_float
    : '(_ FloatingPoint 11 53)'
    ;

cmd_declare_const 
    : 'declare-const'
    ;

declareConsta
    : ParOpen cmd_declare_const var_name_a var_type_bit ParClose
    ;

declareConstb
    : ParOpen cmd_declare_const var_name_b var_type_float ParClose
    ;

fp_consts
    : '(fp #b0 #b00000000000 #b0000000000000000000000000000000000000000000000000000)'
    | '(fp #b1 #b11111111111 #b1111111111111111111111111111111111111111111111111111)'
    ;

rounding_mode
    : 'RNE' 
    | 'RNA'
    | 'RTP'
    | 'RTN'
    | 'RTZ'
    ;

fpabs
    : 'fp.abs'
    ;

fpneg
    : 'fp.neg'
    ;

fpadd 
    : 'fp.add'
    ;

fpsub
    : 'fp.sub'
    ;

fpmul
    : 'fp.mul'
    ;

fpdiv
    :'fp.div'
    ;

fpfma
    : 'fp.fma'
    ;

fpsqrt
    : 'fp.sqrt'
    ;

fproundToIntegral
    : 'fp.roundToIntegral'
    ;

fprem
    : 'fp.rem'
    ;

fpmin
   : 'fp.min'
   ;

fpmax
   : 'fp.max'
   ;

op_tofp
    : '(_ to_fp_unsigned 11 53)'
    ;

fp_term 
    : fp_consts
    | var_name_b
    | ParOpen fpabs fp_term ParClose
    | ParOpen fpneg fp_term ParClose
    | ParOpen fpadd rounding_mode fp_term fp_term ParClose
    | ParOpen fpsub rounding_mode fp_term fp_term ParClose
    | ParOpen fpmul rounding_mode fp_term fp_term ParClose
    | ParOpen fpdiv rounding_mode fp_term fp_term ParClose
    | ParOpen fpfma rounding_mode fp_term fp_term fp_term ParClose
    | ParOpen fpsqrt rounding_mode fp_term ParClose
    | ParOpen fproundToIntegral rounding_mode fp_term ParClose
    | ParOpen fprem fp_term fp_term ParClose
    | ParOpen fpmin fp_term fp_term ParClose
    | ParOpen fpmax fp_term fp_term ParClose
    | ParOpen op_tofp rounding_mode bitvec_term ParClose
    | ParOpen op_tofp rounding_mode int_term ParClose
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

op_fp_to_ubv
    : '(_ fp.to_ubv 64)'
    ;

bitvec_term 
    : bv_const
    | var_name_a
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
    | ParOpen op_fp_to_ubv rounding_mode fp_term ParClose
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

op_fpleq
    : 'fp.leq'
    ;

op_fplt
    : 'fp.lt'
    ;

op_fpgeq
    : 'fp.geq'
    ;

op_fpgt
    : 'fp.gt'
    ;

op_fpeq 
    : 'fp.eq'
    ;

bitvec_comparison
    : ParOpen op_bvult bitvec_term bitvec_term ParClose
    | ParOpen op_equals bitvec_term bitvec_term ParClose
    | ParOpen op_distinct bitvec_term bitvec_term ParClose
    ;

fp_comparison
    : ParOpen op_fpleq fp_term fp_term ParClose
    | ParOpen op_fplt fp_term fp_term ParClose
    | ParOpen op_fpgeq fp_term fp_term ParClose
    | ParOpen op_fpgt fp_term fp_term ParClose
    | ParOpen op_fpeq fp_term fp_term ParClose
    | ParOpen op_equals fp_term fp_term ParClose
    | ParOpen op_distinct fp_term fp_term ParClose
    ;

int_comparison
    : ParOpen op_equals int_term int_term ParClose
    | ParOpen op_distinct int_term int_term ParClose
    ;

bool_term
    : ParOpen op_not bool_term ParClose
    | ParOpen op_and bool_term bool_term ParClose
    | ParOpen op_or bool_term bool_term ParClose
    | ParOpen op_xor bool_term bool_term ParClose
    | ParOpen op_equals bool_term bool_term ParClose
    | ParOpen op_distinct bool_term bool_term ParClose
    | ParOpen op_ite bool_term bool_term bool_term ParClose
    | bitvec_comparison
    | fp_comparison
    | int_comparison
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
