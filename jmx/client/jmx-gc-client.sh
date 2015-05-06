#!/bin/bash
SCRIPT_DIR=`dirname "$0"`

JMX_PORT="$1"

source "${SCRIPT_DIR}/config.node"
log_prefix="gc-n${N}-${JMX_TYPE}-${JMX_PORT}-${JMX_CONFIG}"
log_dir="${SCRIPT_DIR}/../logs/raw/${log_prefix}"
mkdir -p "${log_dir}"
cd "${SCRIPT_DIR}"
while [ 1 ]; do
  $JAVA -cp jmxclient.jar com.adobe.brobertson.jmx.JMXGarbageCollectorNotificationClient $IP $JMX_PORT $JMX_USERNAME $JMX_PASSWORD 2>> "${log_dir}/${log_prefix}.err" | $ROTATELOGS -l "${log_dir}/${log_prefix}.%Y-%m-%d-%H_%M_%S" $LOG_ROTATE_TIME
  sleep 180
done;
