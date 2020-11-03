#!/bin/bash
export_db(){
printf "\n ${GREEN} Step one \t Dump mysql database\n"

#read username
read -p  'Mysql Username:' mysqlUser


#read database name
read -p 'Mysql database name: ' mysqlDb
echo
# export database
	mysqldump -u $mysqlUser -p $mysqlDb > ${outputPath}/db.sql  --no-tablespaces;
echo "Db Exported"
echo
display_size
echo

}