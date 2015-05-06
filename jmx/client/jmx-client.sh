#!/bin/bash
SCRIPT_DIR=`dirname "$0"`

JMX_TYPE="$1"
JMX_PORT="$2"
JMX_CONFIG="$3"
GC_LOGGING="$4"
THREAD_LOGGING="$5"

source "${SCRIPT_DIR}/config.node"
log_prefix="n${N}-${JMX_TYPE}-${JMX_PORT}-${JMX_CONFIG}"
log_dir="${SCRIPT_DIR}/../logs/raw/${log_prefix}"
mkdir -p "${log_dir}"
cd "${SCRIPT_DIR}"
while [ 1 ]; do
  $JAVA -jar jmxclient.jar $JMX_TYPE $IP $JMX_PORT $JMX_USERNAME $JMX_PASSWORD "$JMX_CONFIG" $SLEEP_TIME $REFRESH_MBEAN_NAMES_EVERY $GC_LOGGING $THREAD_LOGGING 2>> "${log_dir}/${log_prefix}.err" | $ROTATELOGS -l "${log_dir}/${log_prefix}.%Y-%m-%d-%H_%M_%S" $LOG_ROTATE_TIME
  sleep 180
done;
