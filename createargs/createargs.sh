#!/bin/bash

rm -f code
touch code
rm -f ../help
touch ../help

echo -e "\nCommands: \n" >> ../help


while read line; do
	options=$(echo $line | cut -d ":" -f1)
	
	option1=$(echo $options | cut -d "," -f1)
	option2=$(echo $options | cut -d "," -f2)
	
	name=$(echo $line | cut -d ":" -f2)
	
	description=$(echo $line | cut -d ":" -f3)
	
	if [ -z $option2 ]; then
		echo "if [[ \$1 == $option1 ]]; then $name=\$2; fi" >> code
	else
		echo "if [[ \$1 == $option1 || \$1 == $option2 ]]; then $name=\$2; fi" >> code
	fi
	
	echo -e "$option1, $option2" >> ../help
	echo -e "\t$description" >> ../help
done < args.lst








