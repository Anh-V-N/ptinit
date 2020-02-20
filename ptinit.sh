#! /bin/bash
HELP="DESCRIPTION:\n
This script is to prepare tmux session at the begining of a pentest.\n
The first argument can be an IP address or a txt file containing ip addresses of the targets.\n 
It creates the directories, tmux session and set the environment for each of these targets.\n
The script also sets the envrionment variable \$E=<target IP> \$R=<local IP>"
# Check if user input exactly 2 arguments
if [ "$#" -ne 2 ]; then
	echo "[+] Usage: bash $0 <Target IP address/txt file> <local ip add>"
	echo
	echo -e $HELP
	exit 1
fi
# Define function ptinit
ptinit () {
	# Prepare directory structure
	mkdir $ip
	cd $ip
	mkdir -p nmap enum exploit post
	# Create tmux sessions 
	SESSION=$(echo $ip | sed 's/\./\-/g')
	tmux new -d -s $SESSION
	tmux setenv -t $SESSION E $ip
	tmux setenv -t $SESSION R $lhost
	for j in nmap enum exploit post;do
		cd $j 
		tmux new-window -t $SESSION: -n $j
		cd ..
	done
	# Perform some basic nmap scans on nmap windows
	tmux select-window -t 1
	tmux split-window -h
	tmux send-key -t0 "sudo nmap -Pn -sU -v -oA udp $ip" Enter
	tmux send-key -t1 "cd nmap; nmap -Pn -v -p- -sC -sV -oA alltcp $ip" ENTER
    # snmp-check 
	tmux select-window -t 2
	tmux send-key -t2 "snmp-check $ip" Enter
	tmux kill-window -t 0 # Kill Windows 0
	# This is to remind the user of variable E and R
	tmux select-window -t 3
	tmux send-key -t3 "clear; echo export E=$ip; echo export R=$lhost " Enter
	cd ..
	echo "[+]Tmux session for target $ip is ready"
	echo "[+]Access it by:"
	echo " tmux a -t $SESSION"
}

# Check the 2nd argument
if [[ $2 = *"."*"."*"."* ]];then
	lhost=$2
else
	echo "WARNING: $2 is not a valid IP address, environment \$R will not be set"
fi

# Main program
if [[ $1 == *".txt" ]];then # Handle txt file
    for ip in $(cat $1);do
		if [[ $ip = *"."*"."*"."* ]];then
            ptinit
		else echo "$ip is not a valid IP address"
		fi
	done
	echo "[+] Environment is set for hosts listed in $1"
	tmux ls # List running tmux sessions
elif [[ $1 = *"."*"."*"."* ]];then # Handle single IP address
        ip=$1
		ptinit
else echo "[+] Please input valid IP address or a text file contain IP addresses (with txt extension)"
fi
