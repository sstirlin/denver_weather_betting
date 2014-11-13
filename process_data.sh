#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"

for f in `ls "$SCRIPTDIR"/data_downtown/*.html`
do

    timestamp=`echo $f | awk -F '[//.]+' '{print $(NF-1)}' | awk -F 'UTC' '{print $1}'`

    year=`echo $timestamp | awk -F '[-:]+' '{print $1}'`
    month=`echo $timestamp | awk -F '[-:]+' '{print $2}'`
    day=`echo $timestamp | awk -F '[-:]+' '{print $3}'`
    hour=`echo $timestamp | awk -F '[-:]+' '{print $4}'`
    minute=`echo $timestamp | awk -F '[-:]+' '{print $5}'`
    second=`echo $timestamp | awk -F '[-:]+' '{print $6}'`

    epoch=`date --utc "+%s" -d"$year-$month-${day}T$hour:$minute:$second"`

    data=`grep -o '<p class="myforecast-current-lrg">[-0-9]*&deg;F' $f | sed 's/<p class="myforecast-current-lrg">//g' | sed 's/&deg;F//g'`

    # seed the initial value of the clock if necesary and skip to next iteration (as long as temp less than 25 degrees)
    if [ -z $start ]
    then
        if test $data -lt 25
        then
            start=$epoch
            startstr="$year-$month-${day}:$hour:$minute:$second"
        fi
        continue
    fi

    if test $data -ge 25
    then
        echo "Went above 25 degrees... resetting"
        start=$epoch
        startstr="$year-$month-${day}:$hour:$minute:$second"
    else
        cold_duration=`bc <<< "($epoch-$start)"` 
    fi

    cold_seconds=`bc <<< "($cold_duration%60)"`
    cold_minutes=`bc <<< "(($cold_duration/60)%60)"`
    cold_hours=`bc <<< "($cold_duration/3600)"`
    echo $timestamp "|"  $data "degrees | Coldsnap duration:" $cold_hours "h" $cold_minutes "m" $cold_seconds "s"
    if test $cold_duration -ge 259200
    then
        echo "48 hours achieved!"
    fi

done
