# DESCRIPTION

A simple script that setup tmux environment in an organized manner for a penetration testing session.

# USAGE

./ptinit.sh {Target IP address/txt file} {local ip add}

# WHAT IT DOES

The script takes exactly 2 arguments from the user. The first argument can be either an IP address or path to a txt file containing ip addresses of the targets (1 IP adress per line and file name must end with .txt) while the second argument is your box's IP address. It then goes ahead and creates the directories, tmux session and set the environment for each of these targets. Specifically, a directory the target IP address as its name of  will be created along with four sub-directories: nmap, enum, exploit and post. Similarly, a tmux session will be created with the IP address as its name along with 4 Windows that matches the 4 sub-directories. The script then performs some initial nmap scans and a quick snmp-check at their appropriate tmux windows and directories. Finally, it sets the envrionment variable $E to target IP address and $R to local IP address.

# Example

![screenshot 1](/screenshot/Screenshot from 2020-02-20 18-36-16.png)
![screenshot 2](/screenshot/Screenshot from 2020-02-20 18-46-36.png)

