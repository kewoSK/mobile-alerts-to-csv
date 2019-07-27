#!/bin/bash
#
# 2019-07-27, V0.1, https://github.com/kewoSK/mobile-alerts-to-csv/
#
#  Intro
# -------
# (dumb) linux shell script which consumes data from sensors presented
# on mobile-alerts.eu web and transforms them to CSV.
# If you find it useful, I will be happy. If you have any suggestion for improvement, please, file me an issue.
#
# no warranty, positive scenario only, no special error handling
#
#
#  Requirements
# --------------
#  linux version, requires bash, curl, grep and sed 
#
#
#  Initial setup
# ---------------
#  1.) visit https://measurements.mobile-alerts.eu/
#
#  2.) enter your phone ID (from Mobile Alerts app) and hit Show Sensors button
#
#  3.) get DEVICE ("MAC" format; deviceid variable), 
#          VENDOR (GUID format; vendorid variable),
#          APPBUNDLE (app handler; appbundle variable)
#      from hidden fields in page source code for desired sensors
#
#  4.) modify mobile-alerts-to-csv-linux.sh (this) script by editing variables 
#      DEVICE, VENDOR, APPBUNDLE and INTERVAL in CONFIG SECTION according to your needs
#
#  5.) add execute privilege to the script ($ chmod u+x mobile-alerts-to-csv-linux.sh)
#
#
#  CONFIG SECTION
# ----------------

DEVICE="XXXXXXXXXXXX"                          # deviceid
VENDOR="aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"  # vendorid
APPBUNDLE="eu.mobile_alerts.mobilealerts"      # appbundle
INTERVAL="7200"                                # seconds; length of the interval to filter results from sensors

# 
#  HIC SVNT LEONES (do not edit following lines by the hand)
# -----------------------------------------------------------

ETIME=`date +%s`
STIME=`expr ${ETIME} - ${INTERVAL}`

# download page -> recude to table -> parse table -> add timestamps -> output CSV
curl -X POST -H 'Content-Type: application/x-www-form-urlencoded' -d "deviceid=${DEVICE}&vendorid=${VENDOR}&appbundle=${APPBUNDLE}&fromepoch=${STIME}&toepoch=${ETIME}" https://measurements.mobile-alerts.eu/Home/MeasurementDetails -o - | sed -e "s/^[[:space:]]*//g" | tr -d "\n\r" | sed $'s/<table/\\\n<table/g' | sed $'s/<\/table>/<\/table>\\\n/g' | grep table | sed -e $'s/<\/tr>/\\\n/g' -e $'s/<\/t[dh]>/;/g' | sed -e $'s/<[^>]*>//g' | (

	read line
	echo "${line}Epoch"

	while read lne
	do
		[[ ${#lne} -lt 1 ]] && continue #empty line
		DTE="`echo $lne | cut -d';' -f1`"
		TS=`TZ="UTC" date --date "${DTE}" +%s`
		echo "${lne}${TS}"
	done
)
