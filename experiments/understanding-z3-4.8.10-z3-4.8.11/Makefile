CORES=64
NUM_TESTS=5000
<<<<<<< HEAD
NUM_ITERATIONS=6
TIMEOUT_IN_SECS=8.0

FLAGS=-package size-based -package base -package directory -package unix

exp:  
#	rm -rf results
	./bin/run-exp.sh Core 1299 $(NUM_TESTS) $(NUM_ITERATIONS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB)
	./bin/run-exp.sh Bitvectors 807 $(NUM_TESTS) $(NUM_ITERATIONS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB)
	./bin/run-exp.sh Ints 1730 $(NUM_TESTS) $(NUM_ITERATIONS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB)
#	./bin/run-exp.sh Reals 1579 $(NUM_TESTS) $(NUM_ITERATIONS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB)
#	./bin/run-exp.sh MixedIntReal 1491 $(NUM_TESTS) $(NUM_ITERATIONS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB)
	./bin/run-exp.sh BitvectorArrays 538 $(NUM_TESTS) $(NUM_ITERATIONS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB)
	./bin/run-exp.sh Strings 874 $(NUM_TESTS) $(NUM_ITERATIONS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB)
	./bin/run-exp.sh FloatingPoints 275 $(NUM_TESTS) $(NUM_ITERATIONS) $(CORES) $(TIMEOUT_IN_SECS) $(MEMOUT_IN_KB)
	
db: 
	#./bin/create-db.sh BitvectorArrays 1 &
	#./bin/create-db.sh BitvectorArrays 2 &
	#./bin/create-db.sh BitvectorArrays 3 &
	
	#./bin/create-db.sh Bitvectors 1 &
	#./bin/create-db.sh Bitvectors 2 &
	#./bin/create-db.sh Bitvectors 3 &
	
	#./bin/create-db.sh Core 1 & 
	#./bin/create-db.sh Core 2 & 
	#./bin/create-db.sh Core 3 & 
	#	
	#./bin/create-db.sh Ints 1 & 
	#./bin/create-db.sh Ints 2 & 
	#./bin/create-db.sh Ints 3 & 
	#
	#./bin/create-db.sh Reals 1 &
	#./bin/create-db.sh Reals 2 &
	#./bin/create-db.sh Reals 3 &
	#
	#./bin/create-db.sh Strings 1 &
	#./bin/create-db.sh Strings 2 &
	#./bin/create-db.sh Strings 3 &
	# 
	#./bin/create-db.sh FloatingPoints 1 &
	#./bin/create-db.sh FloatingPoints 2 &
	#./bin/create-db.sh FloatingPoints 3 &
	./bin/create-db.sh BitvectorArrays 1 &
	./bin/create-db.sh BitvectorArrays 2 &
	./bin/create-db.sh BitvectorArrays 3 &
	./bin/create-db.sh BitvectorArrays 4 &
	./bin/create-db.sh BitvectorArrays 5 &
	./bin/create-db.sh BitvectorArrays 6 &
	./bin/create-db.sh Bitvectors 1 &
	./bin/create-db.sh Bitvectors 2 &
	./bin/create-db.sh Bitvectors 3 &
	./bin/create-db.sh Bitvectors 4 &
	./bin/create-db.sh Bitvectors 5 &
	./bin/create-db.sh Bitvectors 6 &
	./bin/create-db.sh Core 1 & 
	./bin/create-db.sh Core 2 & 
	./bin/create-db.sh Core 3 & 
	./bin/create-db.sh Core 4 & 
	./bin/create-db.sh Core 5 & 
	./bin/create-db.sh Core 6 & 
	./bin/create-db.sh Ints 1 & 
	./bin/create-db.sh Ints 2 & 
	./bin/create-db.sh Ints 3 & 
	./bin/create-db.sh Ints 4 & 
	./bin/create-db.sh Ints 5 & 
	./bin/create-db.sh Ints 6 & 
	./bin/create-db.sh Strings 1 &
	./bin/create-db.sh Strings 2 &
	./bin/create-db.sh Strings 3 &
	./bin/create-db.sh Strings 4 &
	./bin/create-db.sh Strings 5 &
	./bin/create-db.sh Strings 6 &
	./bin/create-db.sh FloatingPoints 1 &
	./bin/create-db.sh FloatingPoints 2 &
	./bin/create-db.sh FloatingPoints 3 &
	./bin/create-db.sh FloatingPoints 4 &
	./bin/create-db.sh FloatingPoints 5 &
	./bin/create-db.sh FloatingPoints 6 &


csv:
	mkdir -p csv
	#./bin/gen-correctness-csv.sh 1
	#./bin/gen-correctness-csv.sh 2
	#./bin/gen-correctness-csv.sh 3
	./bin/gen-solved-problems-csv.sh 1
	./bin/gen-solved-problems-csv.sh 2
	./bin/gen-solved-problems-csv.sh 3
	./bin/gen-solved-problems-csv.sh 4
	./bin/gen-solved-problems-csv.sh 5
	./bin/gen-solved-problems-csv.sh 6
	#./bin/gen-cumtime.sh
	#./bin/gen-throughput.sh 1
	#./bin/gen-throughput.sh 2
	#./bin/gen-throughput.sh 3


plots: 
	mkdir -p plots 
	#RScript ./bin/correctness_plot.R 1
	#RScript ./bin/correctness_plot.R 2
	#RScript ./bin/correctness_plot.R 3
	#RScript ./bin/cumulative_time_plot.R
	#RScript ./bin/throughput_plot.R 1
	#RScript ./bin/throughput_plot.R 2
	#RScript ./bin/throughput_plot.R 3
	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.03125-2.csv plots/solved-problems-plot-0.03125-1.pdf $(NUM_TESTS)
	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.03125-2.csv plots/solved-problems-plot-0.03125-2.pdf $(NUM_TESTS) 2

#	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.03125-3.csv plots/solved-problems-plot-0.03125-3.pdf $(NUM_TESTS) 3
#	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.03125-2.csv plots/solved-problems-plot-0.03125-1.pdf $(NUM_TESTS)
#	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.03125-2.csv plots/solved-problems-plot-0.03125-2.pdf $(NUM_TESTS) 2
#	RScript ./bin/solved_problems_plot.R csv/solved-problems-0.03125-3.csv plots/solved-problems-plot-0.03125-3.pdf $(NUM_TESTS) 3


run-index-search:
	#rm -rf indices.txt
	#touch indices.txt
	#./bin/index-search-BitvectorArrays|tee -a indices.txt
	#./bin/index-search-Bitvectors|tee -a indices.txt
	#./bin/index-search-Core|tee -a indices.txt
	#./bin/index-search-Ints|tee -a indices.txt 
	#./bin/index-search-Reals|tee -a indices.txt 
	#./bin/index-search-Strings|tee -a indices.txt 
	#./bin/index-search-FloatingPoints| tee -a indices.txt 


index-search-BitvectorArrays:
	@sed -n "1,12p" src/FindIndex.hs > index-search-BitvectorArrays.hs
	@python3 -c "print(''+''.join(open('../../src/BitvectorArrays.hs').readlines()[10:-12]))" >> index-search-BitvectorArrays.hs
	@sed -n "195,220p" src/FindIndex.hs >> index-search-BitvectorArrays.hs
	@ghc ${FLAGS} index-search-BitvectorArrays.hs -o bin/index-search-BitvectorArrays

index-search-Bitvectors:
	@sed -n "1,12p" src/FindIndex.hs > index-search-Bitvectors.hs
	@python3 -c "print(''+''.join(open('../../src/Bitvectors.hs').readlines()[10:-12]))" >> index-search-Bitvectors.hs
	@sed -n "195,220p" src/FindIndex.hs >> index-search-Bitvectors.hs
	@ghc ${FLAGS} index-search-Bitvectors.hs -o bin/index-search-Bitvectors

index-search-Core:
	@sed -n "1,12p" src/FindIndex.hs > index-search-Core.hs
	@python3 -c "print(''+''.join(open('../../src/Core.hs').readlines()[10:-12]))" >> index-search-Core.hs
	@sed -n "195,220p" src/FindIndex.hs >> index-search-Core.hs
	@ghc ${FLAGS} index-search-Core.hs -o bin/index-search-Core 

index-search-Ints:
	@sed -n "1,12p" src/FindIndex.hs > index-search-Ints.hs
	@python3 -c "print(''+''.join(open('../../src/Ints.hs').readlines()[10:-12]))" >> index-search-Ints.hs
	@sed -n "195,220p" src/FindIndex.hs >> index-search-Ints.hs
	@ghc ${FLAGS} index-search-Ints.hs -o bin/index-search-Ints 

index-search-Reals:
	@sed -n "1,12p" src/FindIndex.hs > index-search-Reals.hs
	@python3 -c "print(''+''.join(open('../../src/Reals.hs').readlines()[10:-12]))" >> index-search-Reals.hs
	@sed -n "195,220p" src/FindIndex.hs >> index-search-Reals.hs
	@ghc ${FLAGS} index-search-Reals.hs -o bin/index-search-Reals 

index-search-MixedIntReal:
	@sed -n "1,12p" src/FindIndex.hs > index-search-MixedIntReal.hs
	@python3 -c "print(''+''.join(open('../../src/MixedIntReal.hs').readlines()[10:-12]))" >> index-search-MixedIntReal.hs
	@sed -n "195,220p" src/FindIndex.hs >> index-search-MixedIntReal.hs
	@ghc ${FLAGS} index-search-MixedIntReal.hs -o bin/index-search-MixedIntReal 


index-search-Strings:
	@sed -n "1,12p" src/FindIndex.hs > index-search-Strings.hs
	@python3 -c "print(''+''.join(open('../../src/Strings.hs').readlines()[10:-12]))" >> index-search-Strings.hs
	@sed -n "195,220p" src/FindIndex.hs >> index-search-Strings.hs
	@ghc ${FLAGS} index-search-Strings.hs -o bin/index-search-Strings 

index-search-FloatingPoints:
	@sed -n "1,12p" src/FindIndex.hs > index-search-FloatingPoints.hs
	@python3 -c "print(''+''.join(open('../../src/FloatingPoints.hs').readlines()[10:-12]))" >> index-search-FloatingPoints.hs
	@sed -n "195,220p" src/FindIndex.hs >> index-search-FloatingPoints.hs
	@ghc ${FLAGS} index-search-FloatingPoints.hs -o bin/index-search-FloatingPoints 

index-search-all: index-search-BitvectorArrays index-search-Bitvectors index-search-Core index-search-Ints index-search-Reals index-search-FloatingPoints index-search-Strings


offset-BitvectorArrays:
	../../bin/cfg2rtg ../../smtlib_grammars/BitvectorArrays5.g4 | head -n -12 > BitvectorArrays5-large-enum.hs
	cat misc/large-idx-enumeration >> BitvectorArrays5-large-enum.hs
	ghc ${FLAGS} -package size-based -package base  BitvectorArrays5-large-enum.hs -o bin/BitvectorArrays5-large-enum

offset-Bitvectors:
	../../bin/cfg2rtg ../../smtlib_grammars/Bitvectors5.g4 | head -n -12 > Bitvectors5-large-enum.hs
	cat misc/large-idx-enumeration >> Bitvectors5-large-enum.hs
	ghc ${FLAGS} -package size-based -package base  Bitvectors5-large-enum.hs -o bin/Bitvectors5-large-enum

offset-Core:
	../../bin/cfg2rtg ../../smtlib_grammars/Core5.g4 | head -n -12 > Core5-large-enum.hs
	cat misc/large-idx-enumeration >> Core5-large-enum.hs
	ghc ${FLAGS} -package size-based -package base  Core5-large-enum.hs -o bin/Core5-large-enum

offset-Ints:
	../../bin/cfg2rtg ../../smtlib_grammars/Ints5.g4 | head -n -12 > Ints5-large-enum.hs
	cat misc/large-idx-enumeration >> Ints5-large-enum.hs
	ghc ${FLAGS} -package size-based -package base  Ints5-large-enum.hs -o bin/Ints5-large-enum

offset-MixedIntReal:
	../../bin/cfg2rtg ../../smtlib_grammars/MixedIntReal5.g4 | head -n -12 > MixedIntReal5-large-enum.hs
	cat misc/large-idx-enumeration >> MixedIntReal5-large-enum.hs
	ghc ${FLAGS} -package size-based -package base  MixedIntReal5-large-enum.hs -o bin/MixedIntReal5-large-enum

offset-RealIntsIntVars:
	../../bin/cfg2rtg ../../smtlib_grammars/RealIntsIntVars5.g4 | head -n -12 > RealIntsIntVars5-large-enum.hs
	cat misc/large-idx-enumeration >> RealIntsIntVars5-large-enum.hs
	ghc ${FLAGS} -package size-based -package base  RealIntsIntVars5-large-enum.hs -o bin/RealIntsIntVars5-large-enum

offset-RealIntsRealVars:
	../../bin/cfg2rtg ../../smtlib_grammars/RealIntsRealVars5.g4 | head -n -12 > RealIntsRealVars5-large-enum.hs
	cat misc/large-idx-enumeration >> RealIntsRealVars5-large-enum.hs
	ghc ${FLAGS} -package size-based -package base  RealIntsRealVars5-large-enum.hs -o bin/RealIntsRealVars5-large-enum

offset-Reals:
	../../bin/cfg2rtg ../../smtlib_grammars/Reals5.g4 | head -n -12 > Reals5-large-enum.hs
	cat misc/large-idx-enumeration >> Reals5-large-enum.hs
	ghc ${FLAGS} -package size-based -package base  Reals5-large-enum.hs -o bin/Reals5-large-enum
	
offset-FloatingPoints:
	../../bin/cfg2rtg ../../smtlib_grammars/FloatingPoints5.g4 | head -n -12 > FloatingPoints5-large-enum.hs
	cat misc/large-idx-enumeration >> FloatingPoints5-large-enum.hs
	ghc ${FLAGS} -package size-based -package base  FloatingPoints5-large-enum.hs -o bin/FloatingPoints5-large-enum

offset-Strings:
	../../bin/cfg2rtg ../../smtlib_grammars/Strings5.g4 | head -n -12 > Strings5-large-enum.hs
	cat misc/large-idx-enumeration >> Strings5-large-enum.hs
	ghc ${FLAGS} -package size-based -package base  Strings5-large-enum.hs -o bin/Strings5-large-enum
	
offset-all: offset-BitvectorArrays offset-Bitvectors offset-Core offset-Ints offset-MixedIntReal offset-RealIntsIntVars offset-RealIntsRealVars offset-Reals offset-FloatingPoints offset-Strings


clean: 
	rm -rf *.o *.hi *.java *.interp *.tokens formula.smt2  *.hs
