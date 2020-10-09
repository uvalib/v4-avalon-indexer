#
# Shared definitions
#

# log a message and exit
function report_and_exit {

   local MESSAGE=$1
   echo "$MESSAGE"
   exit 1
}

# print an error message and exit
function error_and_exit {

   local MESSAGE="ERROR: $1"
   report_and_exit "$MESSAGE"
}

# exit if an error
function exit_if_error {

   local STATUS=$1
   local MESSAGE="ERROR: $2"
   if [ $STATUS -ne 0 ]; then
      report_and_exit "$MESSAGE"
   fi
}

# log a message
function log_message {

   local MESSAGE=$1
   echo "INFO: $MESSAGE"
}

# ensure the specific tool is available
function ensure_tool_available {

   local TOOL_NAME=$1
   which $TOOL_NAME > /dev/null 2>&1
   res=$?
   if [ $res -ne 0 ]; then
      error_and_exit "$TOOL_NAME is not available in this environment"
   fi
}

# the current list of ids
export CURRENT_IDS_FILE=current-ids.txt

# the current time (of this iteration)
export CURRENT_TIMESTAMP_FILE=current-time.txt

# the list of ids to be deleted
export DELETE_IDS_FILE=delete-ids.txt

#
# end of file
#
