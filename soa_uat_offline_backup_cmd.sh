#!/bin/sh
#!/bin/bash
set -e
clear
# Parent backup directory
backup_parent_dir="/app_data/soa_backup/soa_backup_server/offline_backup/$(hostname -s)/UAT"
backup_date=`date +%Y_%m_%d_%H_%M`
DOMAIN_HOME="/app_domain/OFM_Domains/OFM_UAT/user_projects/uat_soa_domain"


pwd=$(pwd)
opt=$1
#echo "$opt"


    case $opt in
        "soa domain backup")
            echo "you chose soa domain backup" #Blue
            backup_me="/app_domain/OFM_Domains/OFM_UAT/user_projects/uat_soa_domain"
            backup_parent_dir=${backup_parent_dir}/soa_domain_backup
            backup_dir=${backup_parent_dir}/soa_${backup_date}
            mkdir -p $backup_dir
            
            break
            ;;
        "soa binary backup")
            echo "you chose soa binary backup" #yellow
            backup_me="/app/OFM/OFM_UAT/Middleware/Oracle_Home"
            backup_parent_dir=${backup_parent_dir}/soa_binary_backup
            backup_dir=${backup_parent_dir}/soa_${backup_date}
            mkdir -p $backup_dir

            break
            ;;
        "soa full backup")
            echo "you chose soa full backup"
            backup_me="/app_domain/OFM_Domains/OFM_UAT/user_projects/uat_soa_domain /app/OFM/OFM_UAT/Middleware/Oracle_Home"            
            backup_parent_dir=${backup_parent_dir}/soa_full_backup
            backup_dir=${backup_parent_dir}/soa_${backup_date}
            mkdir -p $backup_dir

            break
            ;;
        "")
	     echo "No Arguments passed !!Quitting script....."
            exit 1
            
            break
            ;;
        *) echo invalid option;;
    esac


if [ "${DOMAIN_HOME}" != "" ]

then

. ${DOMAIN_HOME}/bin/setDomainEnv.sh $* 

cd $pwd

echo "Shutting down SOA Servers"
java weblogic.WLST -skipWLSModuleScanning /app_data/scripts/startup_shutdown_scripts/stopOSBServers.py UAT osb_managed_server1 osb_managed_server2
/app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "STOP"

else
  echo "Environment not set"
  exit 1
fi

# Check and create backup directory
#backup_date=`date +%Y_%m_%d_%H_%M`
#backup_dir=${backup_parent_dir}/soa_${backup_date}
#mkdir -p $backup_dir

# Perform backup
echo $backup_me
#echo $backup_parent_dir
for directory in $backup_me
do
       
        /app_data/scripts/soabackupscripts/offlinebackup/delete_old_backups.sh $backup_parent_dir
        echo "Starting Backup............."
        archive_name=`echo ${directory} | sed s/^\\\/// | sed s/\\\//_/g`
        #touch ${BACKUP_DIR}/${archive_name}.log
        tar pcfzP ${backup_dir}/${archive_name}.tgz ${directory} 2>&1 | tee  ${backup_dir}/${archive_name}.log
        if [ ${result} -ne 0 ]
	then
          echo "${opt} Backup failed" | mailx -s "soa backup results" Vardhan.Degaonkar@mmc.com,Amit.Deo01@mmc.com
	else 
          echo "Backup completed successfully.The path to the backup file is:"${backup_dir} | mailx -s "soa backup results" Vardhan.Degaonkar@mmc.com,Amit.Deo01@mmc.com
        fi
        echo  "Backup successful.The path to the backup file is:"${backup_dir}
        # TODO:check return code of tar
        #TODO:tar -cvpf mybackup.tar myfiles/| xargs -I '{}' sh -c "test -f '{}' && md5sum '{}'" | tee mybackup.md5
done

echo "Starting SOA Servers.........."

/app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "START" 
                        
java weblogic.WLST -skipWLSModuleScanning /app_data/scripts/startup_shutdown_scripts/startOSBServers.py UAT osb_managed_server1 osb_managed_server2