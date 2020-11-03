#!/bin/bash

server_script(){

#files to be uploads
scriptPath=$(pwd)/exported
sourceCode=$scriptPath/kodcms.zip
databaseSql=$scriptPath/db.sql
##script file which will run on server onece

dbConfigFile=$scriptPath/db.php
installScriptFile=""


read -p "Enter remote server address: " target_host
read -p "Enter remote server username: " userName;
#read -sp "Enter ${userName}@${target_host} password: " password
read -p "Enter server web root path: " webroot

#copy files to server

copy_files(){
printf "\n${GREEN}Copying Source code and database to server"
echo
chmod 0777 $dbConfigFile;
# sshpass -p $password
 if  ! scp  -o StrictHostKeyChecking=no  {$sourceCode,$databaseSql,$dbConfigFile} $userName@$target_host:$webroot 2>&1;then
echo "Cannot copy files. Please try again"
exit 1
else
echo "Sourcecode copied"
fi
echo
echo 



}

create_db_config(){
touch $dbConfigFile;
FILE=$dbConfigFile;
read -p 'Database UserName: ' dbUser;
read -p "Database Password for ${dbUser}: " dbpwd;
read -p 'Database Name: ' dbName
/bin/cat <<EOM >$FILE
<?php

return [
    'class' => 'yii\db\Connection',
    'dsn' => 'mysql:host=localhost;dbname=$dbName',
    'username' => '$dbUser',
    'password' => '$dbpwd',
    'charset' => 'utf8',
    'enableSchemaCache' => true,
    'schemaCacheDuration' => 60,
    'schemaCache' => 'cache',
];

EOM

echo
echo "kodcms Database configuration for production file created "
echo
}


#access to server
server_access(){
    echo "Script to run on server"
    echo
#initDbScript=$(pwd)/database.sh
#sshpass -p $password 
ssh  $userName@$target_host "cd ${webroot}; bash" << EOF
 #cd ../../web/;

[ -d ./cms ] && rm -rf ./cms 2>&1
[ -d ./plugins ] && rm -rf ./plugins 2>&1
[ -d ./website ] && rm -rf ./website 2>&1

if unzip -o ./kodcms.zip 2>&1;
then
rm ./kodcms.zip
echo "Zip removed"
echo

chmod 0777 -vR ./website/runtime
echo "Website runtime permission changed"
echo
chmod 0777 -vR ./website/web
echo "Website web permission changed"
echo
chmod 0777 -vR ./website/storage
echo "Website storage permission changed"
echo
chmod 0777 -vR ./plugins/*/*.json
echo "plugins permission changed"
echo
mv ./db.php website/config/db.php 2>&1
echo "db.php moved top website"
echo
mkdir -p ./website/assets/
mkdir -p ./website/runtime
 
printf "\n\n\nAutomated script ended successfully! Than you\n"
exit 0
else
echo "Error on unziping. Please try again."
exit 1
echo

fi
EOF

exit 0
#sshpass -p $password ssh  $userName@$target_host
#ssh $userName@$target_host
}



init_hosts(){

echo "Server initialized"
echo
    create_db_config 2>&1
    copy_files 2>&1
    server_access 2>&1
}
