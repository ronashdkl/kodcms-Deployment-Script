#!/bin/bash
zip_sourcecode(){
echo "Admin right needed"
echo
printf "\n${GREEN} Step Two \t Zip source code.\n\n"

webdir="/var/www/${cmsDomain}/web"

if [ -d $webdir ]

 then

cd $webdir;
echo "${webdir} access granted!"
echo
sudo ls 2>&1;
echo
#zip website
if ! sudo zip -r ${outputPath}kodcms.zip * -x "./error" "cms/vendor/*" "cms/web/*" "cms/src/runtime/*" "cms/src/storage/*" "cms/src/tests" "cms/src/vagrant" "cms/src/*.sql" "cms/template" "cms/clientAssets" "cms/.idea" "website/web/assets/*" "website/resource/*"  2>&1; then
printf "\n Unable to zip source code.  \n check if source code available \n or  try again. "
else
chmod 0777 ${outputPath}kodcms.zip;
printf "\n${NC} Source code Exported \n\n ${GREEN}"
fi


cd $outputPath;
ls
echo
echo $(pwd)
echo
echo "Total sized"
display_size
echo

exit 0;
else
printf "\n Website not found\n"
exit 0;
fi;


}
