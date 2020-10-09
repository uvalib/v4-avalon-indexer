#
# Initial setup and definitions
#

SCRIPTS_DIR=$( (cd -P $(dirname $0) && pwd) )
BASE_DIR=${SCRIPTS_DIR}/..

# source the common stuff
. ${SCRIPTS_DIR}/common.ksh

# create the state directory if it does not exist
if [ ! -d ${BASE_DIR}/${STATE_DIRECTORY} ]; then
   mkdir ${BASE_DIR}/${STATE_DIRECTORY}
fi

# create the last timestamp file if it does not exist
if [ ! -f ${BASE_DIR}/${STATE_DIRECTORY}/${LAST_TIMESTAMP_FILE} ]; then
   log_message "Resetting last run timestamp"
   echo "1970-01-01T00:00:00Z" > ${BASE_DIR}/${STATE_DIRECTORY}/${LAST_TIMESTAMP_FILE}
fi

# create the iteration file if it does not exist
if [ ! -f ${BASE_DIR}/${STATE_DIRECTORY}/${ITERATION_FILE} ]; then
   log_message "Resetting iteration count"
   echo "0" > ${BASE_DIR}/${STATE_DIRECTORY}/${ITERATION_FILE}
fi

# create the list of ids if it does not exist
if [ ! -f ${BASE_DIR}/${STATE_DIRECTORY}/${LAST_IDS_FILE} ]; then
   log_message "Resetting last ID list"
   touch ${BASE_DIR}/${STATE_DIRECTORY}/${LAST_IDS_FILE}
fi

# mark the current time
date -u +"%Y-%m-%dT%H:%M:%SZ" > ${BASE_DIR}/${STATE_DIRECTORY}/${CURRENT_TIMESTAMP_FILE}

# increment the iteration counter
cat ${BASE_DIR}/${STATE_DIRECTORY}/${ITERATION_FILE} | awk '{printf "%s+1\n", $1}' | bc > /tmp/$$
mv /tmp/$$ ${BASE_DIR}/${STATE_DIRECTORY}/${ITERATION_FILE}

#
# end of file
#
