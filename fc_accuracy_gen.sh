#! /usr/bin/bash

# declare the log file to be used
log_file='rx_poc.log'

# extract the number of lines in the log file
lines=$(wc -l $log_file | cut -d " " -f1)
# echo $lines

if [[ $lines < 3 ]]; then
    echo "Not enough data!"
    echo "Please run rx_poc.sh to generate data"
    exit 1
fi

for ((i = 3; i <= lines; i++)); do
    # echo "day $((i - 1)) $(head -$i $log_file | tail -1)"
    today_temp=$(head -$i $log_file | tail -1 | cut -d " " -f4)
    yesterday_fc=$(head -$((i - 1)) $log_file | tail -1 | cut -d " " -f5)
    accuracy=$(($yesterday_fc - $today_temp))

    # assign a label to each forecast based on its accuracy
    if [ -1 -le $accuracy ] && [ $accuracy -le 1 ]; then
        accuracy_range=excellent
    elif [ -2 -le $accuracy ] && [ $accuracy -le 2 ]; then
        accuracy_range=good
    elif [ -3 -le $accuracy ] && [ $accuracy -le 3 ]; then
        accuracy_range=fair
    else
        accuracy_range=poor
    fi

    # append a record to your historical forecast accuracy file
    row=$(tail -1 rx_poc.log)
    year=$(echo $row | cut -d " " -f1)
    month=$(echo $row | cut -d " " -f2)
    day=$(echo $row | cut -d " " -f3)

    if [[ ! -e historical_fc_accuracy.tsv ]]; then
        echo -e "year\tmonth\tday\tobserved\tforecast\taccuracy\taccuracy_range" >historical_fc_accuracy.tsv
    fi

    echo -e "$year\t$month\t$day\t$today_temp\t$yesterday_fc\t$accuracy\t$accuracy_range" >>historical_fc_accuracy.tsv
done
