#Conditionally import wlstModule only when script is executed with jython
if __name__ == '__main__': 
    from wlstModule import *#@UnusedWildImport
import sys
import os
import time

try:	
     connect ('weblogic','welcomemmc1','t3://hr-ofm-adm1.dev.mmc.com:7101')
except Exception,e:
     print "Error while trying to connect to Admin server!!!..trying again on node 2!!"
     connect ('weblogic','welcomemmc1','t3://hr-ofm-adm2.dev.mmc.com:7101')




sr = cmo.getSecurityConfiguration().getDefaultRealm();
rm = sr.lookupRoleMapper('XACMLRoleMapper');
expr = rm.getRoleExpression(None,'Admin');
print expr;
#rm.setRoleExpression(None,'Admin',expr+'|Usr(employee)');

#Other examples
#rm.setRoleExpression(None,'Anonymous','Usr(employee)|Grp(everyone)');
rm.setRoleExpression(None,'Admin','Grp(Administrators)|Usr(ASINGER)');
#rm.setRoleExpression(None,'Admin','Grp(Administrators)|Grp(Deployers)');
print expr;