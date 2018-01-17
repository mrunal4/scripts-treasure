#!/bin/bash

#--------------------------------------------------------------------#
# Getting all subscribers / members list of all the mailing list and email the same  
# File name    : get-all-subscribers-list.sh
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : Sat Dec 23 20:25:15 IST 2017
# Modified by  : None
# Modified on  : Not yet
# Description  : This file is used for getting all subscribers / members list of all the mailing list. Post generation of file with member details, mail the file to concern persons.
# Important    : 1. File should be present on the server having mailing list.
#                2. Ensure mutt is installed and configured properly to send the email finally.
#--------------------------------------------------------------------#


# get the names of all the mailing list present in the current system and capture output in a file (all-lists.txt)
list_lists ceiar | awk -F" -" '{print $1}' | sed '/atching mailing lists found/d' > all-lists.txt

# Traverse through the file line-by-line 
while read line
do
    # Take names one by one (one per line) and trim spaces
    list="$line"
    # remove leading whitespace characters
    list="${list#"${list%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    list="${list%"${list##*[![:space:]]}"}"   
    echo "===$list==="           # Print value for testing purpose
    
    # Export mailing list name and later members in the list
    echo -e "List name: $list" >> list_members.txt
    echo -e "----------" >> list_members.txt
    echo -e "List memebers:" >> list_members.txt
    list_members $list >> list_members.txt

    # print seperators in the file to differentiate the details of multiple mailing lists
    echo -e "" >> list_members.txt
    echo -e "---------------x---------------" >> list_members.txt
    echo -e "" >> list_members.txt
done < all-lists.txt

# mail the file to concern persons as an attachment (if mailserver is configured)
# In the example, we are using "mutt" for sending emails
#   "Please find the members list for all the mailing list in the attached text file." is the content in the body
#   "/home/mrunal/mailing-list/list_members.txt" is full path of the attached file (for attachment use '-a' paramenter)
#   "mailing list: member list of all mailing lists" is subject (for subject use '-s' parameter)
#   "cc@domain.com" is ccing email address (for cc use '-c' parameter)
#   "bcc@domain.com" is bccing email address (for cc use '-b' parameter)
#   -- "mrunal@domain.com, mrecepient@domain.com" is recepients' email address (for recepients use '--' parameter)
#   Do not use any parameter after recepient email address. 
#   For specifying multiple address in email related parameters, use ',' {comma} to seperate multiple emails 
echo "Please find the members list for all the mailing list in the attached text file." | mutt -a "/home/mrunal/mailing-list/list_members.txt" -s "mailing list: member list of all mailing lists" -c "cc@domain.com" -b "bcc@domain.com" -- "mrunal@domain.com, mrecepient@domain.com"

exit 0