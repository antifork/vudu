#!/bin/sh

#
# $Id$
#
# vudu v0.2 - Unix X.25 NUA Scanner
# Copyright (c) 2001 Raptor <raptor@0xdeadbeef.eu.org>
#
# Vudu is a simple X.25 NUA scanner for Unix systems: his
# main goal is portability, so it's written in bourne shell
# scripting language, without fancy stuff. Remember to change 
# the vars to suit your operating system's needs. 
# FOR EDUCATIONAL PURPOSES ONLY.
#
# Tested mainly on Solaris. Thanks to Sentinel for his _old_ code.
#
# Usage example: ./vudu 0208057040 535 542 [who can forget QSD? :)]
#


# Some vars (change them if needed)
tmp=vudu.tmp
valid=vudu.nua
pad=./pad

# Response codes (optimized for Sun pad)
com=Connected
dte=DTE
der="Out Of Order"
rpe="Remote Procedure Error"
na="Access Barred"
occ="Number Busy"

# Command line
base="$1"
start="$2"
end="$3"
suffix="$4"
current=$start

# Interactive logging
echo ""
echo "*** VUDU X.25 Scanner for Unix ***"
echo ""
echo "[ Starting with: ${base}${start} ]"

# Perform the scan
while :
do
        $pad $base$current$suffix >$tmp 2>$tmp
       
# COM (valid NUA)
        if fgrep $com $tmp > /dev/null; then
                echo "${base}${current}${suffix}  (OK)"
                echo "${base}${current}${suffix}  (OK)" >> $valid
# DTE
        elif fgrep $dte $tmp > /dev/null; then
		echo "${base}${current}${suffix}  DTE"
		echo "${base}${current}${suffix}  DTE" >> $valid
# DER (out of order)
	elif fgrep "$der" $tmp > /dev/null; then
		echo "${base}${current}${suffix}  DER"
		echo "${base}${current}${suffix}  DER" >> $valid
# RPE (remote procedure error)
	elif fgrep "$rpe" $tmp > /dev/null; then
		echo "${base}${current}${suffix}  RPE"
		echo "${base}${current}${suffix}  RPE" >> $valid
# NA (access barred)
	elif fgrep "$na" $tmp > /dev/null; then
		echo "${base}${current}${suffix}  N/A"
		echo "${base}${current}${suffix}  N/A" >> $valid
# OCC (number busy)
	elif fgrep "$occ" $tmp > /dev/null; then
		echo "${base}${current}${suffix}  OCC"
		echo "${base}${current}${suffix}  OCC" >> $valid
	else
                echo "${base}${current}${suffix}"
        fi
       
# Go for the next address
        if [ $current -eq $end ]; then
                break
        else
                current=`expr $current + 1`
        fi
done

rm $tmp
echo "[ Ended with: ${base}${end} ]"
echo ""
