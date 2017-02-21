#======================================================
# Script File : monitor_soa_servers.py
# Author      : Amit Deo
# Updated on  : 29th April 2016
#======================================================
import smtplib
import time
import os
import sys
import shlex


 
From = "SOAADMIN@WLSERVER.com"
To   =["Amit.Deo01@mmc.com"]
Date = time.ctime(time.time())
URL=""
domain="" 

def getConnection():
    try:
    
        if len(sys.argv) > 0:
           global domain
           domain=sys.argv[1]
           if "DEV" in domain:
            connect ('weblogic','welcomemmc1','t3://hr-ofm-adm1.dev.mmc.com:7101')
           elif "QA" in domain:
            connect (username='weblogic',password='8"L/"bmw=MvaP5M3=pMB(}\'',url='t3://hr-ofm-adm2.qa.mmc.com:7201')
           elif "UAT" in domain:
            connect ('weblogic','welcomemmcuat1','t3://hr-ofm-adm2.uat.mmc.com:7001')
           elif "DR" in domain:
           #connect(userConfigFile='/app_data/scripts/startup_shutdown_scripts/security/DRUserConfigFile',userKeyFile='/app_data/scripts/startup_shutdown_scripts/security/DRUserKeyFile',url='t3://hr-ofm-adm1.dr.mmc.com:7001')
            connect(username='weblogic',password='welcomemmc007',url='t3://hr-ofm-adm1.dr.mmc.com:7001',timeout=1000)
           elif "PROD" in domain:
            connect(userConfigFile='/app_data/scripts/startup_shutdown_scripts/security/PRODUserConfigFile',userKeyFile='/app_data/scripts/startup_shutdown_scripts/security/PRODUserKeyFile',url='t3://hr-ofm-adm1.prod.mmc.com:7001')
           else:
            print "Environment not set"
            exit()
    except Exception,e:
            mailing('AdminServer','Unable to Connect or Find AdminServer')
            #dumpStack()
            #print '\033[1;31m Unable to Connect or Find AdminServer...\033[0m'
            #print e
            raise
            #exit() 

    

def getServerNames():
    domainConfig()
    return cmo.getServers()
 
def mailing(name, stat):
    serverRuntime()
    serverConfig()
    if stat == 'SHUTDOWN':
        Subject = 'Major: '
    else:
        Subject= 'Critical:'

    #URL='t3://'+str(get('ListenAddress'))+':'+str(get('ListenPort'))
 
    Subject= Subject + 'The Weblogic server instance ' +name + ' is ' + stat
    Text='The Server ' +name +' in '+ domain  +' Environment is '+ stat
    mList = 'Amit.Deo01@mmc.com,Chandresh.Kumar@mmc.com,Vardhan.Degaonkar@mmc.com,Hemang.Contractor@mmc.com,Chandra.Kilaru@mmc.com,'
    mList= mList + 'Chandresh.Kumar@mmc.com,Sudarsan.Kumaran@mmc.com'
    #mList='Amit.Deo01@mmc.com'
    
    Msg = ('From: %s\r\nTo: %s\r\nDate: \%s\r\nSubject: %s\r\n\r\n%s\r\n' %(From, To, Date, Subject, Text))
    cmd = "echo " + Text + " > tmpfile"
    os.system(cmd)

    os.system('/bin/mailx -s "'+Subject+'" -r "SOA-ADMIN" '+ mList +' < tmpfile')
    
    
 
def serverStatus(server): 
     #print '/ServerLifeCycleRuntimes/'+server
     domainRuntime()
     cd('/ServerLifeCycleRuntimes/'+ server)  
     return cmo.getState()
 
def checkStatus():
    try:
        
        getConnection()
        serverNames= getServerNames()
        domainRuntime()
        for name in serverNames:
          if name.getName().startswith('osb'):
             print name.getName()
             serverState = serverStatus(name.getName())
             print serverState
             if serverState == 'SHUTDOWN': 
                mailing(name.getName(), serverState)
             elif serverState == 'UNKNOWN':
                mailing(name.getName(), serverState)
   
    except Exception,e:
               mailing('AdminServer','Unreachable')
               print e
              #dumpStack()
              #raise
 
if __name__== "main":
    redirect('/app_data/scripts/monitoring/logs/status.log', 'false')
    checkStatus()
    print 'done'