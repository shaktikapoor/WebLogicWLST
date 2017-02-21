
#Conditionally import wlstModule only when script is executed with jython
if __name__ == '__main__': 
    from wlstModule import *#@UnusedWildImport
import sys
import os

#url= os.environ["URL"]
domain=None

if len(sys.argv) > 3:
   domain=sys.argv[1]

elif len(os.environ["DOMAIN_HOME"]) > 1:
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
   print "Invalid Arguments"
   exit()

#connect(userConfigFile=userConfigFilePath,userKeyFile=userKeyFilePath,url=url)
#connect(username,password,url)

if domain =='DEV':
     try:	
         connect ('weblogic','welcomemmc1','t3://hr-ofm-adm1.dev.mmc.com:7101')
     except Exception,e:
         print "Error while trying to connect to Admin server!!!..trying again on node 2!!"
         connect ('weblogic','welcomemmc1','t3://hr-ofm-adm2.dev.mmc.com:7101')
    
elif domain =='QA':
     try: 
         connect (username='weblogic',password='8"L/"bmw=MvaP5M3=pMB(}\'',url='t3://hr-ofm-adm1.qa.mmc.com:7201')
     except Exception, e:
    	 print "Error while trying to connect to Admin server!!!..trying again on node 2!!"     
         connect (username='weblogic',password='8"L/"bmw=MvaP5M3=pMB(}\'',url='t3://hr-ofm-adm2.qa.mmc.com:7201')
         
 
elif domain =='UAT':
     try:
         connect ('weblogic','welcomemmcuat1','t3://hr-ofm-adm2.uat.mmc.com:7001')
     except Exception,e:
         print "Error while trying to connect to Admin server!!!..trying again on node 2!!"
         connect ('weblogic','welcomemmcuat1','t3://hr-ofm-adm1.uat.mmc.com:7001')
else:
   print "Error"
   exit()




#connect(userConfigFile='/app_data/scripts/startup_shutdown_scripts/security/PRODUserConfigFile',userKeyFile='/app_data/scripts/startup_shutdown_scripts/security/PRODUserKeyFile',url='t3://hr-ofm-adm1.prod.mmc.com:7001')

#connect(userConfigFile='/app_data/scripts/startup_shutdown_scripts/security/DRUserConfigFile',userKeyFile='/app_data/scripts/startup_shutdown_scripts/security/DRUserKeyFile',url='t3://hr-ofm-dr1.prod.mmc.com:7001')




try:
    if len(sys.argv) == 1:  
        print 'Please invoke script as stopOSBServers <server1> <server2> ...  '
        print 'where server1 server2  ..... etc are name of the server to start' 
    
    
    for osbserver in sys.argv:
        if osbserver.startswith('osb'):
            print 'Stopping Server ',
            print osbserver
            shutdown(osbserver,force='true',block='true')
        print 
    
       
except Exception, e:
    print e 
    print "Error while trying to stop server!!!"
    dumpStack()
    raise 

print 'Shutting down AdminServer'
shutdown('AdminServer',force='true',block='true')   
