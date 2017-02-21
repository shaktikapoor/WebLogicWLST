#!/bin/sh

# WARNING: This script is created by the SOA Admin Team.
# Any changes to this script may corrupt configuration.

pwd=$(pwd)
opt=$1

	
    case $opt in
        "DEV")
            
            . /app_domain/OFM_Domains/OFM_DEV/user_projects/dev_soa_domain/bin/setDomainEnv.sh $* 
            cd $pwd
            java weblogic.WLST -skipWLSModuleScanning /app_data/scripts/monitoring/monitor_soa_servers.py "DEV"
            
            break
            ;;
        "QA")
            . /app_domain/OFM_Domains/OFM_QA/user_projects/qa_soa_domain/bin/setDomainEnv.sh $* 
            cd $pwd
            java weblogic.WLST -skipWLSModuleScanning /app_data/scripts/monitoring/monitor_soa_servers.py "QA"

            break
            ;;
        "UAT")
            . /app_domain/OFM_Domains/OFM_UAT/user_projects/uat_soa_domain/bin/setDomainEnv.sh $* 
            cd $pwd
            java weblogic.WLST -skipWLSModuleScanning /app_data/scripts/monitoring/monitor_soa_servers.py "UAT"

            break
            ;;
        "")
	     echo "No Arguments passed !!Quitting script....."
            exit 1
            
            break
            ;;
        *) echo invalid option;;
    esac
