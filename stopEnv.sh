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
            sleep 5
            echo "Stopping OSB Managed Servers"
            java weblogic.WLST -skipWLSModuleScanning stopOSBServers.py DEV osb_managed_server1 osb_managed_server2 
            /app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "STOP"                    
            echo "Domain ShutDown Complete.To be sure perform sanitycheck using weblogic.pids.pl "
            
            break
            ;;
        "QA ")
            echo "you chose QA environment" #yellow
                     
            
            . ${DOMAIN_HOME}/bin/setDomainEnv.sh $* 
            cd $pwd       
            sleep 5
            echo "Stopping OSB Managed Servers"
            java weblogic.WLST -skipWLSModuleScanning stopOSBServers.py QA osb_managed_server1 osb_managed_server2
            app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "STOP"                     
            echo "Domain ShutDown Complete.To be sure perform sanitycheck using weblogic.pids.pl "
            
            
            break
            ;;
        "UAT ")
            echo "you chose UAT environment"
                      
            
            . ${DOMAIN_HOME}/bin/setDomainEnv.sh $* 
            cd $pwd       
            
            echo "Stopping OSB Managed Servers"
            sleep 5
            java weblogic.WLST -skipWLSModuleScanning stopOSBServers.py UAT osb_managed_server1 osb_managed_server2  
            app_data/scripts/startup_shutdown_scripts/startstopNodeManager.sh "STOP"                   
            echo "Domain ShutDown Complete.To be sure perform sanitycheck using weblogic.pids.pl "
            
            break
            ;;


        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

