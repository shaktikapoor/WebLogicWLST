#!/bin/sh

# WARNING: This script is created by the SOA Admin Team.
# Any changes to this script may corrupt configuration.

pwd=$(pwd)

if [ ${DOMAIN_HOME} == "" ] 
then
   
   echo " Environment not set "
   exit 1
fi


PS3='Please enter your choice: '
options=("DEV " "QA " "UAT " "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "DEV ")
            echo "you chose DEV environment" #Blue
                        
            . ${DOMAIN_HOME}/bin/setDomainEnv.sh $* 
            cd $pwd       
            
            echo "Starting OSB Managed Servers"
            
            /app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "START"
            java weblogic.WLST -skipWLSModuleScanning startOSBServers.py DEV osb_managed_server1 osb_managed_server2
                                 
            
            break
            ;;
        "QA ")
            echo "you chose QA environment" #yellow
            
            
            . ${DOMAIN_HOME}/bin/setDomainEnv.sh $* 
            cd $pwd       
            
            echo "Starting OSB Managed Servers"
            
            /app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "START"
            java weblogic.WLST -skipWLSModuleScanning startOSBServers.py QA osb_managed_server1 osb_managed_server2    
             
            break
            ;;
        "UAT ")
            echo "you chose UAT environment"
           
            . ${DOMAIN_HOME}/bin/setDomainEnv.sh $* 
            cd $pwd       
            
            echo "Starting OSB Managed Servers"
            
            /app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "START"
            
            java weblogic.WLST -skipWLSModuleScanning startOSBServers.py UAT osb_managed_server1 osb_managed_server2    
                             
                        
            break
            ;;


        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
