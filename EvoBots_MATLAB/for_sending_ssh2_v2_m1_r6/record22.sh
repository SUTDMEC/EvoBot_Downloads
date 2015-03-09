#!/bin/bash

duration=20

cvlc http://192.168.28.111/?action=stream --sout file/avi:vid/vid1.avi --sout-display --run-time=$duration vlc://quit &
cvlc http://192.168.28.114/?action=stream --sout file/avi:vid/vid2.avi --sout-display --run-time=$duration vlc://quit &