#!/bin/bash


checkinstall () {
	if (( $(dpkg -l $1 | wc -l | cut -d " " -f1) == 0 )); then
		echo "You need to have $1 installed to use this script."
		read -p "Do you want to install it now? " -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			sudo apt install $1
		else
			echo "Stopping script."
			exit
		fi
	fi
}

help () {
	cat help
	exit 1
}

defaultvalues () {
	directory="output"
	verbose=false
	ports="-p-"
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


#Method to parse the commands with arguments
argparse () {
	if [ -z $# ]; then echo "something went wrong at argparse"; exit 1; fi
	checkcommandformat $1 $2
	getcommand $1 $2
}

#Method to parse the flags
flagparse () {
	if [ -z $# ]; then echo "something went wrong at flagparse"; exit 1; fi

if [[ $1 == -q || $1 == -Q ]]; then ports="-p1-9999"; fi
if [[ $1 == -qq ]]; then ports="--top-ports 100"; fi
if [[ $1 == -v ]]; then verbose=true; fi

}

looparg () {
	#Loop through all arguments.
	while (( "$#" >= 1 )); do
		if [[ "$#" == 1 ]]; then
			flagparse $1
			shift
		else
			if [[ $1 == -* && $2 == -* ]]; then
				flagparse $1
				shift
			else
				argparse $1 $2
				shift 2
			fi
		fi
	done
}

dirformat () {
	#Check that the directory is well formatted with a / at the end.	
	if [[ -n $directory ]]; then
		if [[ $directory == *// ]]; then
			directory=$(echo $directory | rev | cut -d "/" -f2- | rev)
		elif [[ $directory != */ ]]; then
			directory="$directory/"
		fi
		if [[ ! -s $directory ]]; then
			mkdir -p $directory
		fi
	else
		directory="./"
	fi
}

#Module to change path used for saving files
changepath () {
	path=$directory$1
	if [[ $path != */ ]]; then path+="/"; fi
	mkdir -p $path
}


#Then call nmap with given arguments
callnmap () {
	changepath nmap
	
	fastscan=false
	if [[ $fastscan = true ]]; then
		echo "First doing a fast scan on top 100 ports ..."
		nmap --top-ports 100 $1 --open -oN "$path$output.fastscan" 1>/dev/null
		echo "... done. Now do the full scan."
	fi
	
	echo "Reminder: that can take a long time and currently has no way to check the current status."
	
	# userchanged options for nmap
	if [[ -z $nmapoption ]]; then
		nmapoption=$ports
	else	
		echo "User changed options for nmap."
	fi
	
	if [[ $verbose = true ]]; then
		nmap $nmapoption $1 -A -oA "$path$output"
	else
		nmap $nmapoption $1 -A -oA "$path$output" 1>/dev/null
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


#Parse the xml-file to get lists of interesting ports
parsexml () {
	if [[ -s "$path$output.xml" ]]; then
		nmap-parse-output/nmap-parse-output "$path$output.xml" tls-ports > $directory$output.tls
		nmap-parse-output/nmap-parse-output "$path$output.xml" http-ports > $directory$output.http
	fi
}

#Now check for xml output and use the parser to get testssl started
calltestssl () {
	if [[ -s "$path$output.xml" ]]; then
		changepath testssl
		
		maxlines=$(wc -l "$directory$output.tls" | cut -d " " -f1)
		currentline=1
		
		for ele in $(cat "$directory$output.tls"); do
			echo "Using testssl on elment $currentline out of $maxlines elements."
			currentline=$(expr $currentline + 1)
			testssl -oL $path $ele 1>/dev/null
		done
	fi
}



main () {
	#todo in one function with shift
	checkinstall nmap
	checkinstall testssl.sh
	checkinstall xsltproc
	
	defaultvalues
	looparg $@
	dirformat

	parsenmap
	parsexml
	calltestssl
	#todo: callsshaudit
}
main $@

























