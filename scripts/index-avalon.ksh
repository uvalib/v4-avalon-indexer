#
# Pull Solr records from Avalon, transform them and send to Virgo4 ingest
#

SCRIPTS_DIR=$( (cd -P $(dirname $0) && pwd) )
BASE_DIR=${SCRIPTS_DIR}/..

# source the configuration
. ${BASE_DIR}/config/config.env

# source the common stuff
. ${SCRIPTS_DIR}/common.ksh

# do the setup necessary
${SCRIPTS_DIR}/setup.ksh

# add the exit handler
function onexit {
   ${SCRIPTS_DIR}/cleanup.ksh
}
trap onexit EXIT

# make list of everything to be deleted
${SCRIPTS_DIR}/make-delete-ids.ksh
exit_if_error $? "Making the delete list"

# and upload to staging and production
${SCRIPTS_DIR}/upload-delete-file.ksh ${BASE_DIR}/${STATE_DIRECTORY}/${DELETE_IDS_FILE} staging
${SCRIPTS_DIR}/upload-delete-file.ksh ${BASE_DIR}/${STATE_DIRECTORY}/${DELETE_IDS_FILE} production

# get the latest Avalon documents
${SCRIPTS_DIR}/make-update-docs.ksh
exit_if_error $? "Making the update list"

# and upload to staging and production
${SCRIPTS_DIR}/upload-update-file.ksh ${BASE_DIR}/${STATE_DIRECTORY}/${UPDATE_DOCS_FILE} staging
${SCRIPTS_DIR}/upload-update-file.ksh ${BASE_DIR}/${STATE_DIRECTORY}/${UPDATE_DOCS_FILE} production

# all over
exit 0

#
# end of file
#
