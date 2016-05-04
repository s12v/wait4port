#!/usr/bin/env bash

trap term SIGTERM SIGINT

RETRIES=120
DELAY=0.5

term() { 
	echo "Caught SIGTERM/SIGINT signal!" 
	for p in $pids; do
		kill $p
	done  
}

try_address() {
	local address="$1"
	IFS=':' read -ra arr <<< "$address"
	local m1=${arr[0]}
	local m2=${arr[1]}
	local m3=${arr[2]}

	if [[ $m1 =~ ^http.?$ ]] && [ ! -z "$m2" ] && [[ $m3 =~ ^[0-9]+$ ]]; then
		local cmd="curl -s -o /dev/null $m1:$m2:$m3"
		tput setaf 4; echo -n "$address (curl)"; tput sgr0
	elif [ ! -z "$m1" ] && [[ $m2 =~ ^[0-9]+$ ]]; then
		local cmd="nc -z $m1 $m2"
		tput setaf 5; echo -n "$address (nc) "; tput sgr0
	else
		echo "Invalid parameters: $address"
		exit 1
	fi

	if [ ! -z "$cmd" ]; then
		for i in `seq 1 $RETRIES`; do
			if $cmd 2> /dev/null; then
				tput setaf 2; echo -n " $address up! "; tput sgr0
				exit 0;
			fi
			echo -n "."
		  	sleep $DELAY
		done
	fi

	tput setaf 1; echo -n " $address timeout "; tput sgr0
	exit 1
}

echo -n "Waiting for connections: "
commands=""
pids=""
for address; do
	( try_address $address ) & pid=$!
	commands[$pid]=$address
	pids+=" $pid"
	sleep 0.1
done

ret=0
for p in $pids; do
	if ! wait $p; then
		ret=1
	fi
done

echo ""
exit $ret
