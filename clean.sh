#!/bin/bash
sudo docker stop $(sudo docker ps -qa)
sudo docker container rm $(sudo docker container ls -aq)
sudo docker rmi -f $(sudo docker images -qa)