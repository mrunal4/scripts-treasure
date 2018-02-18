#!/bin/bash

#--------------------------------------------------------------------#
# Create and start syncthing docker   
# File name    : setup-docker-syncthing.sh
# File version : 1.0
# Created by   : Mr. Mrunal M. Nachankar
# Created on   : Sun Feb 18 19:48:53 IST 2018
# Modified by  : None
# Modified on  : Not yet
# Description  : This file is used for creating and starting syncthing docker container
# Important    : 1. docker and docker-compose needs to be pre-installed
#                2. Download this file in linux operating system
#                3. Trigger the file with 'bash setup-docker-syncthing.sh' command
#                4. Check for status column of the last output
#--------------------------------------------------------------------#


echo -e "Create syncthing docker container"
docker create \
  --name=syncthing \
  -v /syncthing-vol/config:/config \
  -v /syncthing-vol/data:/data \
  -e PGID=1000 -e PUID=1000  \
  -e UMASK_SET=022 \
  -p 8384:8384 -p 22000:22000 -p 21027:21027/udp \
  linuxserver/syncthing

echo -e "Start syncthing docker container"
docker start syncthing

echo -e "Check the status of syncthing docker container (Check the status column)"
docker ps -a
