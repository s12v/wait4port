#!/usr/bin/env bash
trap : SIGTERM SIGINT

RETRIES=120
DELAY=0.5

try_address() {
	arr=(${1//:/ })

	local host=${arr[0]}
	local port=${arr[1]}
	if [ ! -z "$host" ] && [[ $port =~ ^[0-9]+$ ]]; then
		local c=0
		while ! nc -z "$host" "$port" 2> /dev/null; do
			if [ "$c" -ge $RETRIES ]; then exit 1; fi
			echo -n "."
		  	sleep $DELAY
		  	c=$((c + 1))
		done
	else
		echo "Invalid parameters: $host:$port"
		exit 1
	fi
}

echo -n "Waiting for TCP connections "
commands=""
pids=""
for address; do
	( try_address $address ) & pid=$!
	commands[$pid]=$address
	pids+=" $pid"
done

ret=0
for p in $pids; do
	if wait $p; then
		tput setaf 2
		echo -n " ${commands[$p]} up! "
		tput sgr0
	else
		if [ "$?" -gt 128 ]; then
			kill $?
		else
			tput setaf 1
			echo -n " ${commands[$p]} timeout "
			tput sgr0
		fi
		ret=1
	fi
done

echo ""
exit $ret
