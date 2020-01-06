#!/bin/sh

set -e

echo "Waiting to ensure everything is fully ready for the tests..."
sleep 90

echo "Checking main containers are reachable..."
if ! ping -c 10 -q 'pdns-server' ; then
    echo 'PowerDNS Server container is not responding!'
    # TODO Display logs to help bug fixing
    #echo 'Check the following logs for details:'
    #tail -n 100 logs/*.log
    exit 1
fi

if ! ping -c 10 -q 'powerdns-admin' ; then
    echo 'PowerDNS-Admin container is not responding!'
    # TODO Display logs to help bug fixing
    #echo 'Check the following logs for details:'
    #tail -n 100 logs/*.log
    exit 2
fi

# XXX Add your own tests
# https://docs.docker.com/docker-hub/builds/automated-testing/
#echo "Executing PowerDNS-Admin app tests..."
## TODO Test result of tests

# Success
echo 'Docker tests successful'
exit 0
