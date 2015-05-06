#!/bin/sh
echo BEFORE
ps -fU $USER | egrep 'sh jmx-(gc-)?client' | egrep -v '(SCREEN|grep)'
echo KILLING OLD
ps -fU $USER | egrep 'sh jmx-(gc-)?client' | egrep -v '(SCREEN|grep)' | awk '{print $2}' | xargs kill
echo AFTER
ps -fU $USER | egrep 'sh jmx-(gc-)?client' | egrep -v '(SCREEN|grep)'
echo STARTING
sh start.sh
