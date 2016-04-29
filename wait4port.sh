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
		while ! nc -z "$host" "$port"; do
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

commands=""
pids=""
for address; do
    ( try_address $address ) &
    pid=$!
    pids+=" $pid"
    commands[$pid]=$address
done

ret=0
for p in $pids; do
    if wait $p; then
    	tput setaf 2
        echo -n "${commands[$p]}: ok "
    else
    	if [ "$?" -gt 128 ]; then
    		kill $?
    	else
	    	tput setaf 1
	        echo -n "${commands[$p]}: timeout "
    	fi
        ret=1
    fi
done

echo ""
exit $ret
