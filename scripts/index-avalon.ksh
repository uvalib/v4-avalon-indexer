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

# get the complete list of Avalon ID's; we use this to determine if anything needs to be deleted
${SCRIPTS_DIR}/get-all-ids.ksh

#
# end of file
#
