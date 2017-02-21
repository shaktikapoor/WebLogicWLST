#Conditionally import wlstModule only when script is executed with jython
if __name__ == '__main__': 
    from wlstModule import *#@UnusedWildImport
import sys
import os
import time
#url= os.environ["URL"]
domain=None

if len(sys.argv) > 3:
   domain=sys.argv[1]

elif os.environ["DOMAIN_HOME"] != '':
     domain=os.environ["DOMAIN_HOME"]
     if "DEV" in domain:
         domain="DEV"
     elif "QA" in domain:
           domain="QA"
     elif "UAT" in domain:
          domain="UAT"
     else:
        print "Environment not set"
        exit()
else:
   print "Environment not set"
   exit()

#print "Starting AdminServer..........."

if domain =='DEV':
   try:
        nmConnect('weblogic','welcomemmc1', 'USFKL24AS60','5556','dev_soa_domain',nmType='plain')
   except:
       exit()
       print "Error while connecting to NodeManager"       
       #startNodeManager()  
    
   nmStart('AdminServer','/app_domain/OFM_Domains/OFM_DEV/user_projects/dev_soa_domain')
   adminServerStatus = nmServerStatus('AdminServer')
   if adminServerStatus =='RUNNING':
      nmDisconnect()
      connect ('weblogic','welcomemmc1','t3://hr-ofm-adm1.dev.mmc.com:7101')
   else:
      print "Error starting AdminServer"
      nmDisconnect()
      exit()

elif domain =='QA':
     try:
         nmConnect("weblogic",'8"L/"bmw=MvaP5M3=pMB(}\'','USFKL24AS60','5557','qa_soa_domain',nmType='plain')
     except:
        print 'Error connecting to NodeManager.'       
        #startNodeManager()
        exit()

     nmStart('AdminServer','/app_domain/OFM_Domains/OFM_QA/user_projects/qa_soa_domain')
     adminServerStatus = nmServerStatus('AdminServer')
     if adminServerStatus =='RUNNING':
        nmDisconnect()
        connect (username='weblogic',password='8"L/"bmw=MvaP5M3=pMB(}\'',url='t3://hr-ofm-adm2.qa.mmc.com:7201')
     else:
        print "Error starting AdminServer"
        nmDisconnect()
        exit()


elif domain =='UAT':
     try:
	     nmConnect("weblogic",'welcomemmcuat1','USFKL24AS60','5558','uat_soa_domain',nmType='SSL')
     except:
         print 'Error connecting to NodeManager.'       
       	 #startNodeManager()

     nmStart('AdminServer','/app_domain/OFM_Domains/OFM_UAT/user_projects/uat_soa_domain')
     adminServerStatus = nmServerStatus('AdminServer')
     if adminServerStatus =='RUNNING':
        nmDisconnect()
        connect ('weblogic','welcomemmcuat1','t3://hr-ofm-adm2.uat.mmc.com:7001')
     else:
        print "Error starting AdminServer"
        nmDisconnect()
        exit()
 
else:
   print "Environment not Set"
   exit()


#connect(userConfigFile=userConfigFilePath,userKeyFile=userKeyFilePath,url=url)
#connect(username,password,url)
#connect(userConfigFile='/app_data/scripts/startup_shutdown_scripts/security/PRODUserConfigFile',userKeyFile='/app_data/scripts/startup_shutdown_scripts/security/PRODUserKeyFile',url='t3://hr-ofm-adm1.prod.mmc.com:7001')

#connect(userConfigFile='/app_data/scripts/startup_shutdown_scripts/security/DRUserConfigFile',userKeyFile='/app_data/scripts/startup_shutdown_scripts/security/DRUserKeyFile',url='t3://hr-ofm-dr1.prod.mmc.com:7001')




try:
    if len(sys.argv) == 1:  
        print 'Please invoke script as startOSBServers <server1> <server2> ...  '
        print 'where server1 server2  ..... etc are name of the server to start' 
    
    
    for osbserver in sys.argv:
        if osbserver.startswith('osb'):
            print 'Starting Server ',
            print osbserver
            start(osbserver,block='true')
        print 
    
       
except Exception, e:
    print e 
    print "Error while trying to start server!!!"
    dumpStack()
    raise 

 
