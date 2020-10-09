#
# Cleanup after running
#

SCRIPTS_DIR=$( (cd -P $(dirname $0) && pwd) )
BASE_DIR=${SCRIPTS_DIR}/..

# source the common stuff
. ${SCRIPTS_DIR}/common.ksh

# informational
log_message "Cleaning up"

#
# end of file
#
