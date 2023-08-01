#! /usr/bin/bash

# create a datestamped filename for the ray wttr data
today=$(date +%Y%m%d)
weather_report=raw_data_$today

# download today's weather report from wttr.in
city=Casablanca
curl wttr.in/$city -o $weather_report

# extract all lines containing temperatures from the report and write to file
grep °C $weather_report >temperatures.txt

# extract the current temperature
obs_tmp=$(cat -A temperatures.txt | head -1 | cut -d "+" -f2 | cut -d "m" -f5 | cut -d "^" -f1)
echo "observed temperature = $obs_tmp"

# extract the forecast for noon tomorrow
fc_temp=$(cat -A temperatures.txt | head -3 | tail -1 | cut -d "+" -f2 | cut -d "(" -f1 | cut -d "^" -f1)

# use command substitution to store the current day, month, and year in corresponding variables
hour=$(TZ='Morocco/Casablanca' date -u +%H)
day=$(TZ='Morocco/Casablanca' date -u +%d)
month=$(TZ='Morocco/Casablanca' date +%m)
year=$(TZ='Morocco/Casablanca' date +%Y)

record=$(echo -e "$year\t$month\t$day\t$obs_tmp\t$fc_temp")
echo $record >>rx_poc.log
