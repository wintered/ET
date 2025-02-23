grammar FloatingPoints;

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
    : '(_ FloatingPoint 11 53)'
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

fp_term 
    : fp_consts
    | var_name_a
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
    ;

op_equals
    : '='
    ;

op_distinct
    : 'distinct'
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

bool_term
    : ParOpen op_equals fp_term fp_term ParClose
    | ParOpen op_distinct fp_term fp_term ParClose
    | ParOpen op_fpleq fp_term fp_term ParClose
    | ParOpen op_fplt fp_term fp_term ParClose
    | ParOpen op_fpgeq fp_term fp_term ParClose
    | ParOpen op_fpgt fp_term fp_term ParClose
    | ParOpen op_fpeq fp_term fp_term ParClose
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
