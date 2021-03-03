# stdcheck-network

Scripting your simple network scans and generating findings.

# Download

Please download via
* git clone --recursive https://www.github.com/jakesamu/stdcheck-network

# Install

Every time you call this script it checks if you have necessary packages installed and wants to install them automatically (you need to give sudo rights for that).

You can also use `./install.sh' to install the necessary packages.

# Dependencies

This tool is written on and for kali linux. It should work on debian based systems too.

# Usage
Use `./stdcheck-network.sh` - it prints the help.

# ToDo

* Check/Debug all parameters (like -n)
* Add to install.sh the check, that every submodule exists
* Get findings out of testssl-output
* Generate a list or table, preferrably a csv, that presents a good overview for findings.
* Same for ssh with ssh-audit - that also means contributing to nmap-parser

# Disclaimer

This is still work in progress.
This is not meant to be a masterpiece but more some small scripting that I thought would be fun to do.
