mkdir mdapi_output_dir
sfdx force:source:convert -d mdapi_output_dir/ -n PCKG00
sfdx force:mdapi:deploy -d mdapi_output_dir/ -u "$orgAlias" -w -1
rm -rf mdapi_output_dir