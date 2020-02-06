#!/bin/bash
loggerName="hookListener.sh:"
var="Nothing"
amountOfFailures=0
maxAmountOfFailures=10
while [ $amountOfFailures -lt $maxAmountOfFailures ]
do
        var=$(nc -p port -l | jq -r '.repoName')
        case $var in
                yourFirstCase ) #this is the content of the field .repoName
                        logger "$loggerName fetching and rebuilding ParkingManager..."
                        /etc/systemd/system/updateParkingManager.sh ;;
                * ) #this is the default case
                        amountOfFailures=$(( $amountOfFailures+1 ))
                        logger "$loggerName No case for repoName: $var ,amount of failures: $amountOfFailures" ;;
        esac
done
logger "$loggerName Closing off script, too many unknown parameters!"
