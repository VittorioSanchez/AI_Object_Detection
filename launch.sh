#!/bin/bash

cd /home/siec/Desktop/git/siecCAN/aarch64/bin/GEIcar_Project

export ROS_MASTER_URI=http://169.254.130.178:11311
export ROS_IP=169.254.82.228

python3.6 main.py
