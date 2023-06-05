mkdir temp
sfdx force:mdapi:retrieve -r temp -o "$orgAlias" -k manifest/package.xml
unzip temp/unpackaged.zip -d temp
sfdx force:mdapi:convert -r temp