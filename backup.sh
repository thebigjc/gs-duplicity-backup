#!/bin/bash 


WAITTIME=${BACKUP_WAITTIME:-60}
SRC_DIR=${BACKUP_SOURCE:-/data}

sed -i "s/<gs_access_key_id>/${GS_ACCESS_KEY_ID}/" /.boto
sed -i "s/<gs_secret_access_key>/${GS_ACCESS_KEY_ID}/" /.boto
sed -i "s/<default_project_id>/${GS_PROJECT_ID}/" /.boto

duplicity --allow-source-mismatch --no-encryption ${SRC_DIR} ${BACKUP_DEST}

INOTIFYWAIT_EVENTS="modify,attrib,move,create,delete"

while inotifywait -r -e ${INOTIFYWAIT_EVENTS} ${SRC_DIR} ; do
  echo "Change detected."
  while inotifywait -r -t ${WAITTIME} -e ${INOTIFYWAIT_EVENTS} ${SRC_DIR} ; do
    echo "waiting for quiet period.."
  done

  echo "starting backup"
  duplicity --no-encryption --allow-source-mismatch --full-if-older-than 7D ${SRC_DIR} ${BACKUP_DEST}
  echo "starting cleanup"
  duplicity remove-all-but-n-full 3 --force --no-encryption --allow-source-mismatch ${BACKUP_DEST}
  duplicity cleanup --force --no-encryption ${BACKUP_DEST}
done

