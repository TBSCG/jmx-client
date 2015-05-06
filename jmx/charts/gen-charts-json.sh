#!/bin/bash
SCRIPT_DIR=`dirname $0`
SCRIPT_DIR=`readlink -f "$SCRIPT_DIR"`
BASE_DIR=`readlink -f "$SCRIPT_DIR/../"`
cd $BASE_DIR

for i in `find logs/raw -maxdepth 1 -type d -name "c*n*" | sort`; do 
   c=`basename "$i"`;
   echo $c; 
   pushd "$i" > /dev/null; 

   charts_dir="$BASE_DIR/logs/charts-json/${c}"
   rm -r "$charts_dir"
   mkdir -p "$charts_dir"

   for num_files in 1 2 6; do
     dir="$charts_dir/last_${num_files}_periods"
     ls -1 *.20* | tail -n $num_files | xargs cat | "$SCRIPT_DIR/split-charts-json.pl" $dir;
   done;  
   popd > /dev/null; 
done;

