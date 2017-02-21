#!/bin/sh
#!/bin/bash
set -e
trap '' HUP
cmd=$1
pwd=$(pwd)



if [ ${DOMAIN_HOME} == "" ] 
then
   
   echo " Environment not set "
   exit 1
fi

function getNmStatus () {

 #pgrep -lf "startNodeManager.sh" | grep ${DOMAIN_HOME} | wc -l
  
  shortDomainName=`echo ${DOMAIN_HOME} | cut -c25-31`
  ps -ef | grep NodeManager | grep ${shortDomainName} | wc -l

}


echo "NodeManager status is:"$(getNmStatus)

if [[ "${cmd}" == "START" && "$(getNmStatus)" < 1 ]]
then
 
 cd $WLS_HOME/bin
 . ./setWLSEnv.sh > /dev/null
 
 cd ${DOMAIN_HOME}/bin
 echo "Starting NodeManger....."
 nohup ./startNodeManager.sh > /dev/null 2>&1 &
  
 sleep 15
  
  if [ "$(getNmStatus)" -gt 0 ]
  then echo "Node manager started successfully. "
  else
    echo " Node manager startup failed !!"
  fi

elif [[ "${cmd}" == "STOP" && "$(getNmStatus)" > 0 ]]
then

 cd ${DOMAIN_HOME}/bin
 echo "Stopping NodeManager...."
 #nohup ./stopNodeManager.sh > /dev/null 2>&1 &
 ./stopNodeManager.sh 
 sleep 5

  if [ "$(getNmStatus)" -lt 1 ]
  then echo "Node manager stopped successfully."
  else
    echo " Node manager stop failed !!"
  fi
else
  echo "Invalid argument:$cmd "
  exit 1

fi

cd $pwd



 

