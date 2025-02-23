CORES=64
NUM_TESTS=1000000
TIMEOUT_IN_SECS=8.0
MEMOUT_IN_KB=1048576

exp:
	./bin/run-exp.sh Core $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	#./bin/run-exp.sh BitvectorArrays $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	#./bin/run-exp.sh Bitvectors $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	#./bin/run-exp.sh Ints $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	#./bin/run-exp.sh MixedIntReal $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	#./bin/run-exp.sh RealIntsIntVars $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	#./bin/run-exp.sh RealIntsRealVars $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	#./bin/run-exp.sh Reals $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	#./bin/run-exp.sh Strings $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	#./bin/run-exp.sh FloatingPoints $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 

db:
	#./bin/create-db.sh BitvectorArrays &
	#./bin/create-db.sh Bitvectors &
	./bin/create-db.sh Core & 
	#./bin/create-db.sh Ints & 
	#./bin/create-db.sh MixedIntReal &
	#./bin/create-db.sh RealIntsIntVars &
	#./bin/create-db.sh RealIntsRealVars&
	#./bin/create-db.sh Reals &
	#./bin/create-db.sh Strings &
	#./bin/create-db.sh FloatingPoints

csv:
	mkdir -p csv
	#./bin/gen-correctness-csv.sh
	./bin/gen-solved-problems-csv.sh
	./bin/gen-cumtime.sh
	#./bin/gen-throughput.sh
