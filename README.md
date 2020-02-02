# Execute script when Oracle DB is ready for use

The goal of this project is to provide a way of detecting when an oracle db is ready for use then running a command when it is.
This is currently done using the wait-for-oracledb.sh script which will try to select from the V$INSTANCE view and get the status of the instance specified.  The script accepts some options to configure the connection to the database.  The default options are configured for a containerized oracle 12.2 db running with the default options. The script is useful for running containers that depend on an oracle db.

## Getting Started

To get started, clone this repo and ensure the prerequiste packages are installed.

### Prerequisites
+ libaio, called libaio1 on some package managers like apt-get
+ oracle instantclient basiclite [download version 19.5 here](https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-basiclite-linux.x64-19.5.0.0.0dbru.zip)
+ opacle instantclient sqlplus [download version 19.5 here](https://download.oracle.com/otn_software/linux/instantclient/195000/instantclient-sqlplus-linux.x64-19.5.0.0.0dbru.zip)

### Installing

Make sure the directory where the oracle instant client basiclite libraries are is part of your LD_LIBRARY_PATH
`LD_LIBRARY_PATH=/path/to/basiclite/libraries:"${LD_LIBRARY_PATH}"`

Also make sure that sqlplus is your PATH
`PATH=/path/to/sqlplus/binary:"${PATH}"`

### Usage

`./wait-for-oracledb.sh [-h host] [-S sid] [-D domain] [-u user] [-p password] [-R role] [-I poll_interval] command [args]`

The script can accept a variety of options, but they default to values set as the defaults for the oracle db 12.2 image. The only required argument is the command which will be run when the db is in a ready state.

example `./wait-for-oracledb.sh echo 'The database is ready to for use.'`

#### Options
+ `-h host` - specify a host. default: localhost
+ `-S sid` - specify database sid. default: ORCLCDB
+ `-D domain` - database domain server. default: localdomain
+ `-u user` - database user used for checking instance status. default: sys
+ `-p password` - database user password. default: Oradoc_db1
+ `-R role` - database user role. default: sysdba
+ `-I poll_interval` - how long should the process sleep between polls of instance status. default: 5 seconds

### Examples

See the examples folder for usage examples