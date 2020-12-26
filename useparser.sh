#!/bin/bash


help () {
	cat help
	exit 1
}

#Method to check that first argument starts with -
checkcommandformat () {
	if [[ $1 != -* ]]; then
		echo "Please check argument \"$1\", it is not a command option."
		help
	fi
	if [[ $2 == -* ]]; then
		echo "Please check argument \"$2\", it should not be a command option."
		help
	fi
}

#Interpreter for arguments an corresponding action
getcommand () {
	#include everything from createargs/code

if [[ $1 == -f || $1 == -F ]]; then file=$2; fi
if [[ $1 == -u || $1 == -U ]]; then hostname=$2; fi
if [[ $1 == -n || $1 == -N ]]; then nmapoption=$2; fi
if [[ $1 == -o || $1 == -O ]]; then output=$2; fi
if [[ $1 == -d || $1 == -D ]]; then directory=$2; fi

}


#Method to parse the given arguments
argparse () {
	if [ -z $# ]; then echo "something went wrong at argparse"; fi
	checkcommandformat $1 $2
	getcommand $1 $2
	
	if [[ -n $directory ]]; then
		if [[ $directory == *// ]]; then
			directory=$(echo $directory | rev | cut -d "/" -f2- | rev)
		elif [[ $directory != */ ]]; then
			directory="$directory/"
		fi
	else
		$directory="./"
	fi
}

#Loop through all arguments.
while (( "$#" >= 2 )); do
	argparse $1 $2
	shift 2
done

#Then call nmap with given arguments
callnmap () {
	echo "First doing a fast scan on top 100 ports ..."
	nmap --top-ports 100 $1 --open -oN "$directory$output.fastscan" 1>/dev/null
	echo "... done. Now do the full scan."
	
	echo "Reminder: that can take a long time and currently has no way to check the current status."
	
	if [[ -z $nmapoption ]]; then
		nmap -p80,443 -A $1 -oA "$directory$output" 1>/dev/null
	else
		echo "User changed options for nmap."
		nmap $nmapoption $1 -A -oA "$directory$output" 1>/dev/null
	fi
}

parsenmap () {
	if [[ -n $file ]]; then
		if [[ -s $file ]]; then
			if [[ -z $output ]]; then output=$(echo $file | rev | cut -d "/" -f1 | rev); fi
			callnmap "-iL $file"
		else
			echo "File \"$file\" not found."
		fi
	elif [[ -n $hostname ]]; then
		if [[ -z $output ]]; then output=$hostname; fi
		callnmap $hostname
	else
		echo "No file or hostname was given."
		help
	fi
}
parsenmap


#Now check for xml output and use the parser to get testssl started
alltestssl () {
	if [[ -s "$directory$output.xml" ]]; then
		nmap-parse-output/nmap-parse-output "$directory$output.xml" tls-ports > $directory$output.tls
		
		maxlines=$(wc -l "$directory$output.tls" | cut -d " " -f1)
		currentline=1
		
		for ele in $(cat "$directory$output.tls"); do
			echo "Using testssl on elment $currentline out of $maxlines elements."
			currentline=$(expr $currentline + 1)
			testssl -oL $directory $ele 1>/dev/null
		done
	fi
}
alltestssl




