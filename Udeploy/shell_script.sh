#!/bin/bash

SQL_SERVER="your_sql_server"
DATABASE="your_database"
USERNAME="your_username"
PASSWORD="your_password"
QUERY="your_sql_query"

/path/to/sqlcmd -S $SQL_SERVER -d $DATABASE -U $USERNAME -P $PASSWORD -Q "$QUERY"
