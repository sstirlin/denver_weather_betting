#!/bin/bash

# run this as a CRON job every 5 minutes

SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"

# make data directories
[ -d "$SCRIPTDIR/data_downtown" ] || mkdir "$SCRIPTDIR/data_downtown"
[ -d "$SCRIPTDIR/data_airport" ] || mkdir "$SCRIPTDIR/data_airport"

DATA=$(curl -L http://forecast.weather.gov/MapClick.php\?lat\=39.739146640000456\&lon\=-104.98469734299971\&site\=all\&smap\=1\#.VGFK8vnF_VU)
echo $DATA > "$SCRIPTDIR/data_downtown"/`date --utc +%Y-%m-%d:%H:%M:%S`UTC.html

DATA=$(curl -L http://forecast.weather.gov/MapClick.php\?lat\=39.8517086490005\&lon\=-104.67343746999967\&site\=all\&smap\=1\#.VGFZb_nF_VU)
echo $DATA > "$SCRIPTDIR/data_airport"/`date --utc +%Y-%m-%d:%H:%M:%S`UTC.html

