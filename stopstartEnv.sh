#!/bin/sh

# WARNING: This file is created by the SOA Admin Team.
# Any changes to this script may corrupt configuration.

pwd=$(pwd)

if [ ${DOMAIN_HOME} == "" ] 
then
   
   echo " Environment not set "
   exit 1
fi


echo="======================================================================================================="
echo=""
echo="======================================================================================================="


PS3='Please enter your choice: '
options=("DEV " "QA " "UAT " "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "DEV ")
            echo "you chose DEV environment" #Blue
            #export DOMAIN="DEV"          
            . ${DOMAIN_HOME}/bin/setDomainEnv.sh $* 
            cd $pwd       
            
            echo "Stopping OSB Managed Servers"
            java weblogic.WLST -skipWLSModuleScanning stopOSBServers.py DEV osb_managed_server1 osb_managed_server2
            /app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "STOP"                      
            #sleep 30
            /app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "START" 
            java weblogic.WLST -skipWLSModuleScanning startOSBServers.py DEV osb_managed_server1 osb_managed_server2
            
            
            
            break
            ;;
        "QA ")
            echo "you chose QA environment" #yellow
            . ${DOMAIN_HOME}/bin/setDomainEnv.sh $* 
            cd $pwd       
            
            echo "Stopping Domain Servers"
            java weblogic.WLST -skipWLSModuleScanning stopOSBServers.py osb_managed_server1 osb_managed_server2
            /app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "STOP"                      
            sleep 30
            echo "Initiating Domain StartUp..................."
            /app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "START" 
            java weblogic.WLST -skipWLSModuleScanning startOSBServers.py osb_managed_server1 osb_managed_server2                     

            break
            ;;
        "UAT ")
            echo "you chose UAT environment"
           export DOMAIN="UAT"
            . ${DOMAIN_HOME}/bin/setDomainEnv.sh $* 
            cd $pwd          
            echo "Stopping OSB Managed Servers"
            java weblogic.WLST -skipWLSModuleScanning stopOSBServers.py osb_managed_server1 osb_managed_server2    
            /app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "STOP"                 
            sleep 30
            /app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "START"  
            java weblogic.WLST -skipWLSModuleScanning startOSBServers.py osb_managed_server1 osb_managed_server2
              
            
            break
            ;;


        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done



