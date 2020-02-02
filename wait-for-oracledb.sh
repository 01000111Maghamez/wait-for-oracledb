#!/bin/bash

COMMAND_NAME="${0}"

DB_HOST=localhost
DB_SID=ORCLCDB
DB_DOMAIN=localdomain
DB_USER=sys
DB_USER_PASS=Oradoc_db1
DB_USER_ROLE=sysdba
POLL_INTERVAL=5

QUERY_INSTANCE_STATUS='SELECT INSTANCE_NAME, STATUS FROM V$INSTANCE;'

function usage() {
  echo "${COMMAND_NAME} [-h host] [-S sid] [-D domain] [-u user] [-p password] [-R role] [-I poll_interval] command [args]"
}

# expects a command in $1
function connect_and_run_command() {
  echo "${1}" | sqlplus "${DB_USER}/${DB_USER_PASS}@${DB_HOST}/${DB_SID}.${DB_DOMAIN} as ${DB_USER_ROLE}"
}

# expects sqlplus query result in $1 and 
function extract_instance_status() {
  echo "${1}" | grep "${DB_SID}" | sed --expression='s/\s\+/,/' | cut -d',' -f2
}

function get_instance_status() {
  QUERY_RESULT=$(connect_and_run_command "${QUERY_INSTANCE_STATUS}")
  STATUS=$(extract_instance_status "${QUERY_RESULT}")
  echo "${STATUS}"
}

function wait_for_instance_open_status() {
  INSTANCE_STATUS=$(get_instance_status)
  while [ "${INSTANCE_STATUS}" != 'OPEN' ]
  do
    sleep "${POLL_INTERVAL}"
    INSTANCE_STATUS=$(get_instance_status)
  done
  "${COMPLETION_COMMAND}" "${COMPLETION_COMMAND_ARGS}"
}

function get_option_value() {
  if [ $# -gt 1 ] 
  then
    echo $1
  else
    exit 1
  fi
}

if [ $# -lt 1 ] 
then
  usage
  exit 1
fi

while [ $# -gt 0 ] 
do
  ARG=$1
  shift
  if [ ${ARG} == '-h' ]
  then
    DB_HOST=$(get_option_value "$@")
    [ $? -ne 0 ] && usage && exit $?
  elif [ ${ARG} == '-S' ]
  then
    DB_SID=$(get_option_value "$@")
    [ $? -ne 0 ] && usage && exit $?
  elif [ ${ARG} == '-D' ]
  then
    DB_DOMAIN=$(get_option_value "$@")
    [ $? -ne 0 ] && usage && exit $?
  elif [ ${ARG} == '-u' ]
  then
    DB_USER=$(get_option_value "$@")
    [ $? -ne 0 ] && usage && exit $?
  elif [ ${ARG} == '-p' ]
  then
    DB_USER_PASS=$(get_option_value "$@")
    [ $? -ne 0 ] && usage && exit $?
  elif [ ${ARG} == '-R' ]
  then
    DB_USER_ROLE=$(get_option_value "$@")
    [ $? -ne 0 ] && usage && exit $?
  elif [ ${ARG} == '-I' ]
  then
    POLL_INTERVAL=$(get_option_value "$@")
    [ $? -ne 0 ] && usage && exit $?
  else
    COMPLETION_COMMAND=${ARG}
    COMPLETION_COMMAND_ARGS=$@
  fi
  shift
done

wait_for_instance_open_status