# Custom-CI-script
This is my very own, quite basic, custom CI script I run on my Arch RPi.
I use a `.service` file to start it on boot.

The file features a basic switch case. This allows you to launch different scripts from the same listening port.

*This script requires both `netcat` and [`jq`](https://github.com/stedolan/jq)
The idea is for it to be used in conjunction with my [CustomHookAction](https://github.com/ByRicardoSimoes/CustomHookAction), but considering how `jq` can handle any
JSON-based payload you can even use normal GitHub Webhooks with this script.

## How does it work

```bash
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
                        /your/directory/your/script.sh ;;
                * ) #this is the default case
                        amountOfFailures=$(( $amountOfFailures+1 ))
                        logger "$loggerName No case for repoName: $var ,amount of failures: $amountOfFailures" ;;
        esac
done
logger "$loggerName Closing off script, too many unknown parameters!"
```

What we have here is the full script. It contains some variables to make it easier for us to change its behaviour.

`loggerName` is a simple identifier so you can find it in the normal logging data of your OS. on Arch, this would be `journalctl`
`var` is a temporary variable that holds the data with filter the payload for.
`amountOfFailures` count's how often we've received bad data
`maxAmountOfFailures` determines how often bad data can be received before the script (the while loop) stops.

`var=$(nc -p port -l | jq -r '.repoName')` This right here does the following:
    - opens a `netcat` socket on `port` (replace with your port) and `-l`istens for incoming data
    - `jq -r .repoName` get's the raw data of the variable `repoName` inside the JSON payload. Without `-r` your `var` will contain the quotation marks

Replace `yourFirstCase` with the String you're expecting in the payload
Replace `/your/directory/your/script.sh` with the path to the script you want to execute