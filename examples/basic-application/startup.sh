#!/bin/bash

echo 'database is ready!'
echo "SELECT USERNAME FROM ALL_USERS;" | sqlplus "sys/Oradoc_db1@${DB_HOST}:1521/ORCLCDB.localdomain as sysdba"