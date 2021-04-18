# netchecker

Scripting your simple network scans and generating findings.

# Download

Please download via the following command, otherwise submodules will not be downloaded.
* git clone --recursive https://www.github.com/jakesamu/netchecker

# Install

Every time you call this script it checks if you have necessary packages installed and wants to install them automatically (you need to give sudo rights for that).

You can also use `./install.sh' to install the necessary packages.

# Dependencies

This tool is written on and for kali linux. It should work on debian based systems too.

# Usage
Use `./netchecker.sh` - it prints the help.

# ToDo

* Either warn, or remodel parser, for start-tls modes (smtp, imap, ...)

* searchsploit for all the found versions, also document stuff like found versions
* Generate a list or table, preferrably a csv, that presents a good overview for findings.

# Disclaimer

This is still work in progress.
This is not meant to be a masterpiece but more some small scripting that I thought would be fun to do.
