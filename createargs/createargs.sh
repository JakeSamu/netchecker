#!/bin/bash

rm -f commands
rm -f flags
rm -f ../help

rm -f ../help-commands
rm -f ../help-flags


while read line; do
	options=$(echo $line | cut -d ":" -f1)
	name=$(echo $line | cut -d ":" -f2)
	description=$(echo $line | cut -d ":" -f3)
	
	option1=$(echo $options | cut -d "," -f1)
	option2=$(echo $options | cut -d "," -f2)
	

	if [ -z $name ]; then
		varname=$(echo $line | cut -d "," -f4)
		trueval=$(echo $line | cut -d "," -f5)
		falseval=$(echo $line | cut -d "," -f6)
		
		if [ -z $option2 ]; then
			echo "if [[ \$1 == $option1 ]]; then $varname=$trueval; else $varname=$falseval; fi" >> flags
		else
			echo "if [[ \$1 == $option1 || \$1 == $option2 ]]; then $varname=$trueval; else $varname=$falseval; fi" >> flags
		fi
		
		echo -e "$option1, $option2" >> ../help-flags
		echo -e "\t$description" >> ../help-flags
	else
		if [ -z $option2 ]; then
			echo "if [[ \$1 == $option1 ]]; then $name=\$2; fi" >> commands
		else
			echo "if [[ \$1 == $option1 || \$1 == $option2 ]]; then $name=\$2; fi" >> commands
		fi
		
		echo -e "$option1, $option2" >> ../help-commands
		echo -e "\t$description" >> ../help-commands
	fi
	
	
done < args.lst



echo -e "\nCommands: \n" >> ../help
cat ../help-commands >> ../help

echo -e "\nFlags: \n" >> ../help
cat ../help-flags >> ../help

rm -f ../help-commands
rm -f ../help-flags

echo "" >> ../help








