#!/bin/sh

# Monitor all clusters for jmx attributes
screen -d -m -S "Jboss 1" sh jmx-client.sh jboss 9998 jboss-example-config.tsv false 0; 

# Monitor only cluster 3 for jmx gc notifications
screen -d -m -S "GC Cluster 1" sh jmx-gc-client.sh 9998;

screen -ls
