TIMEOUT=3600 # 3600 seconds
KILL_TIMEOUT=10  # Kill the process after 10 seconds if not exited after sending terminate signal
OUTPUT_FILE=outpus_new.csv

echo "Benchmark,Result,Time (seconds)" > $OUTPUT_FILE
for name in car discrete logistic sgd sgd_001 cav13-1 cav13-2 unicycle cohencu circuit deter bound1 bound2 contrived transcend basin lyapunov motivate
do
cmd="timeout -k $KILL_TIMEOUT $TIMEOUT python3 Code/synthesizer.py --filename inputs/$name/$name.c --target ./outputs/$name/"
echo "Running $cmd..."

start_time=`date +%s.%3N`
output=$(eval $cmd || echo "Timeout")
end_time=`date +%s.%3N`
time_taken=`echo $end_time - $start_time | bc`

if [[ "$output" == "Timeout" ]];
then
	echo "$name, TIMEOUT, -" >> $OUTPUT_FILE
else
	echo "$name, SUCCESS, $time_taken" >> $OUTPUT_FILE
fi
done
