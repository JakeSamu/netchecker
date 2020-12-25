# stdcheck-network

Scripting your simple network scans and generating findings.

# ToDo

* Use nmap on hostnames or ip-range - split that shit up to make one fast scan, which is like top 1000 ports. Then make a full scan.
* Use the full scan for testssl on all ports. Generate a list/table (csv would be best), with the ip and ports.
* * Ask thorsten to use the testssl-wrapper or generate one alone for standard findings and output that into csv too
* Same for ssh with ssh-audit
* Ask to install nmap, ssh-audit and testssl if they are not installed

* Question yourself if you want to do that with bash or python.
