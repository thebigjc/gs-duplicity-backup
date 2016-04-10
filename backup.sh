#!/bin/bash 

sed -i "s/<gs_access_key_id>/${GS_ACCESS_KEY_ID}/" /.boto
sed -i "s/<gs_secret_access_key>/${GS_ACCESS_KEY_ID}/" /.boto
sed -i "s/<default_project_id>/${GS_PROJECT_ID}/" /.boto

duplicity --allow-source-mismatch --no-encryption /data ${BACKUP_DEST}
