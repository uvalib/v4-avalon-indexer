#
# Helper script to copy a file to a specified bucket/path
#

SCRIPTS_DIR=$( (cd -P $(dirname $0) && pwd) )
BASE_DIR=${SCRIPTS_DIR}/..

# source the common stuff
. ${SCRIPTS_DIR}/common.ksh

# check command line use
if [ $# -ne 2 ]; then
   echo "use: $(basename $0) <source file> <destination bucket/path>"
   exit 1
fi

AWS_TOOL=aws
ensure_tool_available ${AWS_TOOL}

# verify environment
if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
   error_and_exit "AWS_ACCESS_KEY_ID is not definied, aborting"
fi
if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
   error_and_exit "AWS_SECRET_ACCESS_KEY is not definied, aborting"
fi
if [ -z "${AWS_REGION}" ]; then
   error_and_exit "AWS_REGION is not definied, aborting"
fi

SRC_PATH=$1
DST_PATH=$2
log_message "Uploading ${SRC_PATH} -> s3://${DST_PATH}"
#${AWS_TOOL} s3 cp ${SRC_PATH} s3://${DST_PATH}
exit $?

#
# end of file
#
