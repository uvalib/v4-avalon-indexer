#
# Make a list of new or updated documents
#

SCRIPTS_DIR=$( (cd -P $(dirname $0) && pwd) )
BASE_DIR=${SCRIPTS_DIR}/..

# source the common stuff
. ${SCRIPTS_DIR}/common.ksh

CURL_TOOL=curl
ensure_tool_available ${CURL_TOOL}

# get the last timestamp
LAST_TIMESTAMP=$(cat ${BASE_DIR}/${STATE_DIRECTORY}/${LAST_TIMESTAMP_FILE} | awk '{print $1}')

SOLR_OPTS="indent=on&wt=xml&rows=1000000"
SOLR_QUERY="q=${RECORD_TYPE_FIELD}:${RECORD_TYPE}+${RECORD_MODIFIED_FIELD}:\[${LAST_TIMESTAMP}%20TO%20NOW\]&${SOLR_OPTS}"

# informational
log_message "Getting records since ${LAST_TIMESTAMP}..."

${CURL_TOOL} "${SOLR_URL}/select?${SOLR_QUERY}" 2> /dev/null > ${BASE_DIR}/${STATE_DIRECTORY}/${CURRENT_DOCS_FILE}
exit_if_error $? "Getting records from Solr"

# filter unneeded

# run the transform(s)

# temp
cp ${BASE_DIR}/${STATE_DIRECTORY}/${CURRENT_DOCS_FILE} ${BASE_DIR}/${STATE_DIRECTORY}/${UPDATE_DOCS_FILE}

# update the last timestamp
mv ${BASE_DIR}/${STATE_DIRECTORY}/${CURRENT_TIMESTAMP_FILE} ${BASE_DIR}/${STATE_DIRECTORY}/${LAST_TIMESTAMP_FILE}

# all over
exit 0

#
# end of file
#
