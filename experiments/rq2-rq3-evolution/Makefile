CORES=92
NUM_TESTS=1000000
TIMEOUT_IN_SECS=8.0
MEMOUT_IN_KB=1048576

gen-testers:
	cd ../../; bin/gen_tester grammars/Core.g4
	cd ../../; bin/gen_tester grammars/Ints.g4
	cd ../../; bin/gen_tester grammars/RealInts.g4
	cd ../../; bin/gen_tester grammars/Reals.g4
	cd ../../; bin/gen_tester grammars/Bitvectors.g4
	cd ../../; bin/gen_tester grammars/Arrays.g4
	cd ../../; bin/gen_tester grammars/FP.g4
	cd ../../; bin/gen_tester grammars/Strings.g4

exp:
	./bin/run-exp.sh Core $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	./bin/run-exp.sh Ints $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	./bin/run-exp.sh RealInts $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	./bin/run-exp.sh Reals $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	./bin/run-exp.sh Bitvectors $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	./bin/run-exp.sh Arrays $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	./bin/run-exp.sh FP $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 
	./bin/run-exp.sh Strings $(NUM_TESTS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB) 

db:
	./bin/create-db.sh Core &
	./bin/create-db.sh Ints &
	./bin/create-db.sh RealInts & 
	./bin/create-db.sh Reals &
	./bin/create-db.sh Bitvectors &
	./bin/create-db.sh Arrays &
	./bin/create-db.sh FP &
	./bin/create-db.sh Strings & 

gen-csv:
	mkdir -p csv
	./bin/gen-solved-problems-csv.sh
	./bin/gen-correctness-csv.sh
	./bin/gen-cumtime.sh
	./bin/gen-throughput.sh

avg:
	python3 bin/avg.py results-0/csv/correctness_results.csv results-1/csv/correctness_results.csv num_triggers 
	python3 bin/avg.py results-0/csv/solved-problems-0.015625.csv results-1/csv/solved-problems-0.015625.csv count
	python3 bin/avg.py results-0/csv/solved-problems-0.03125.csv results-1/csv/solved-problems-0.03125.csv count
	python3 bin/avg.py results-0/csv/solved-problems-0.0625.csv results-1/csv/solved-problems-0.0625.csv count 
	python3 bin/avg.py results-0/csv/solved-problems-0.125.csv results-1/csv/solved-problems-0.125.csv count 
	python3 bin/avg.py results-0/csv/solved-problems-0.25.csv results-1/csv/solved-problems-0.25.csv count
	python3 bin/avg.py results-0/csv/solved-problems-0.5.csv results-1/csv/solved-problems-0.5.csv count
	python3 bin/avg.py results-0/csv/solved-problems-1.csv results-1/csv/solved-problems-1.csv count
	python3 bin/avg.py results-0/csv/solved-problems-2.csv results-1/csv/solved-problems-2.csv count
	python3 bin/avg.py results-0/csv/solved-problems-4.csv results-1/csv/solved-problems-4.csv count
	python3 bin/avg.py results-0/csv/solved-problems-8.csv results-1/csv/solved-problems-8.csv count
	python3 bin/avg.py results-0/csv/cumulative_time.csv results-1/csv/cumulative_time.csv cumulative_time
	python3 bin/avg.py results-0/csv/throughput.csv results-1/csv/throughput.csv throughput
	mkdir -p csv 
	mv *.avg csv


gen-plots: 
	mkdir -p plots 
	RScript ./bin/intro-plot-correctness.R
	RScript ./bin/intro-plot-performance.R
	RScript ./bin/correctness_plot.R csv/correctness_results.csv.avg correctness 
	RScript ./bin/cumulative_time_plot.R
	RScript ./bin/throughput_plot.R 
	RScript ./bin/focused-solved-problems.R csv/solved-problems-0.015625.csv.avg
	RScript ./bin/focused-solved-problems.R csv/solved-problems-0.03125.csv.avg
	RScript ./bin/focused-solved-problems.R csv/solved-problems-0.0625.csv.avg
	RScript ./bin/focused-solved-problems.R csv/solved-problems-0.125.csv.avg
	RScript ./bin/focused-solved-problems.R csv/solved-problems-0.25.csv.avg
	RScript ./bin/focused-solved-problems.R csv/solved-problems-0.5.csv.avg
	RScript ./bin/focused-solved-problems.R csv/solved-problems-1.csv.avg
	RScript ./bin/focused-solved-problems.R csv/solved-problems-2.csv.avg
	RScript ./bin/focused-solved-problems.R csv/solved-problems-4.csv.avg
	RScript ./bin/focused-solved-problems.R csv/solved-problems-8.csv.avg
	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.015625.csv.avg plots/solved-problems-plot-0.015625.pdf $(NUM_TESTS)
	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.03125.csv.avg plots/solved-problems-plot-0.03125.pdf $(NUM_TESTS)
	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.03125.csv.avg plots/solved-problems-plot-0.03125.pdf $(NUM_TESTS)
	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.0625.csv.avg plots/solved-problems-plot-0.0625.pdf $(NUM_TESTS)
	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.125.csv.avg plots/solved-problems-plot-0.125.pdf $(NUM_TESTS)
	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.25.csv.avg plots/solved-problems-plot-0.25.pdf $(NUM_TESTS)
	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.5.csv.avg plots/solved-problems-plot-0.5.pdf $(NUM_TESTS)
	RScript ./bin/solved_problems_plot.R csv/solved-problems-1.csv.avg plots/solved-problems-plot-1.pdf $(NUM_TESTS)
	RScript ./bin/solved_problems_plot.R csv/solved-problems-2.csv.avg plots/solved-problems-plot-2.pdf $(NUM_TESTS)
	RScript ./bin/solved_problems_plot.R csv/solved-problems-4.csv.avg plots/solved-problems-plot-4.pdf $(NUM_TESTS)
	RScript ./bin/solved_problems_plot.R csv/solved-problems-8.csv.avg plots/solved-problems-plot-8.pdf $(NUM_TESTS)
	

correctness-table:
	python3 bin/gen-correctness-table.py

clean:
	rm -rf csv plots
