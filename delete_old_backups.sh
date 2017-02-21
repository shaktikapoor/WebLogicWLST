#!/bin/sh
#!/bin/bash
set -e

backup_base_dir="/app_data/soa_backup/backup_server/offline_backup"
backup_dir=$1


if [[ "$backup_dir" == *"$backup_base_dir"* ]]

then

echo "backup folder is >>"$backup_dir

cd /$backup_dir

  OUTPUT="$(ls -lR | grep ^d | wc -l)"
  #echo "${OUTPUT}"

if (($OUTPUT > 2));

then
      

echo "Deleting old backup directories from :> "$backup_dir

       rm -rf $(ls -1t $backup_dir | tail -n +3) 

       sleep 5
 
       echo "Old backups deleted successfully."
       
       sleep 5
       clear
else
 
  echo "No backup directories to delete."

fi

else
  echo "Wrong directory"
  exit 1

fi

