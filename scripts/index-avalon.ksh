#
# Pull Solr records from Avalon, transform them and send to Virgo4 ingest
#

SCRIPTS_DIR=$( (cd -P $(dirname $0) && pwd) )
BASE_DIR=${SCRIPTS_DIR}/..

# source the configuration
. ${BASE_DIR}/config/config.env

# do the setup necessary
${SCRIPTS_DIR}/setup.ksh

# add the exit handler
function onexit {
   ${SCRIPTS_DIR}/cleanup.ksh
}
trap onexit EXIT

# make list of everything to be deleted
${SCRIPTS_DIR}/make-delete-ids.ksh

# and upload to staging and production
${SCRIPTS_DIR}/upload-delete-file.ksh staging
${SCRIPTS_DIR}/upload-delete-file.ksh production

# get the latest Avalon documents
${SCRIPTS_DIR}/make-update-docs.ksh

# and upload to staging and production
${SCRIPTS_DIR}/upload-update-file.ksh staging
${SCRIPTS_DIR}/upload-update-file.ksh production

# all over
exit 0

#
# end of file
#
