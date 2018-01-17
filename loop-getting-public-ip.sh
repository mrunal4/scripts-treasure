#!/bin/bash

#--------------------------------------------------------------------#
# Getting public ip of the system 
# File name    : loop-getting-public-ip.sh
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : Wed Dec 20 16:22:21 IST 2017
# Modified by  : None
# Modified on  : Not yet
# Description  : This file is used for getting public ip. To monitor continuosly public ip infinite loop is used. Press [CTRL+C] to stop/exit...
#--------------------------------------------------------------------#

# Print message "Press [CTRL+C] to stop/exit..."
echo "Press [CTRL+C] to stop/exit..." ;

# Infinte loop using while loop. (To print it only once, comment all lines after this except line starting with "echo")
while :
do
    # "date" command is used to print date. It is a linux system command. "dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}'" is used to get public ip.
    echo "$(date)   -   $(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')" ;
done  

exit 0