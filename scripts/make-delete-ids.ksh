#
# Make a list of ID's that need to be deleted
#

SCRIPTS_DIR=$( (cd -P $(dirname $0) && pwd) )
BASE_DIR=${SCRIPTS_DIR}/..

# source the common stuff
. ${SCRIPTS_DIR}/common.ksh

CURL_TOOL=curl
ensure_tool_available ${CURL_TOOL}
JQ_TOOL=jq
ensure_tool_available ${JQ_TOOL}

SOLR_OPTS="wt=json&fl=id&rows=1000000"
SOLR_QUERY="q=${RECORD_TYPE_FIELD}:${RECORD_TYPE}&${SOLR_OPTS}"

log_message "Getting all Avalon record ID's..."

${CURL_TOOL} "${SOLR_URL}/select?${SOLR_QUERY}" 2> /dev/null | ${JQ_TOOL} ".response.docs[].id" | tr -d "\"" | sort > ${BASE_DIR}/${STATE_DIRECTORY}/${CURRENT_IDS_FILE}
exit_if_error $? "Getting ID's from Solr"

# create a list of ids that no longer exist
comm -23 ${BASE_DIR}/${STATE_DIRECTORY}/${LAST_IDS_FILE} ${BASE_DIR}/${STATE_DIRECTORY}/${CURRENT_IDS_FILE} > ${BASE_DIR}/${STATE_DIRECTORY}/${DELETE_IDS_FILE}

#
# end of file
#
