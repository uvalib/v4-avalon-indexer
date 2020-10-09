#
# Upload the list of ID's to be deleted
#

SCRIPTS_DIR=$( (cd -P $(dirname $0) && pwd) )
BASE_DIR=${SCRIPTS_DIR}/..

# source the configuration
. ${BASE_DIR}/config/config.env

# source the common stuff
. ${SCRIPTS_DIR}/common.ksh

# check command line use
if [ $# -ne 2 ]; then
   echo "use: $(basename $0) <source file> <environment>"
   exit 1
fi

SOURCE=$1
ENVIRONMENT=$2

# check file exists
if [ ! -f ${SOURCE} ]; then
   error_and_exit "${SOURCE} is not available or readable"
fi

LINES=$(wc -l ${SOURCE} | awk '{print $1}')
if [ "${LINES}" == "0" ]; then
   echo "Delete file is empty, doing nothing"
   exit 0
fi

# define the current iteration
ITERATION=$(cat ${BASE_DIR}/${STATE_DIRECTORY}/${ITERATION_FILE} | awk '{print $1}')

# create the target name template
TARGET_TEMPLATE=${S3_INGEST_BUCKET}/${S3_DOC_DELETE}/${S3_DELETE_FILE}
YEAR=$(date -u +"%Y")
TARGET_NAME=$(echo $TARGET_TEMPLATE | sed -e "s/XX_YEAR_XX/${YEAR}/g" | sed -e "s/XX_ENVIRONMENT_XX/${ENVIRONMENT}/g" | sed -e "s/XX_ITERATION_XX/${ITERATION}/g")

# upload to S3...
${SCRIPTS_DIR}/s3-upload.ksh ${SOURCE} ${TARGET_NAME}
exit $?

#
# end of file
#
