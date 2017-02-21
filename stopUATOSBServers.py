
#Conditionally import wlstModule only when script is executed with jython
if __name__ == '__main__': 
    from wlstModule import *#@UnusedWildImport
import sys
import os


username = 'op'
password = 'ss0m1ddleware'
#url='prdesoa041.unix.gsm1900.org:7001'
#url='prdesoa011.unix.gsm1900.org:7001'
url='prdesoa011.unix.gsm1900.org:6501'

connect(username,password,url)
print
try:
    if len(sys.argv) == 1:  
        print 'Please invoke script as stopESOAServer <server1> <server2> ...  '
        print 'where server1 server2 server3 ..... etc are name of the server to start' 
    
    
    for esoaserver in sys.argv:
        if esoaserver.startswith('ESOA'):
            print 'Stopping Server ',
            print esoaserver
            shutdown(esoaserver,force='true',block='false')
        print 
    
       
except Exception, e:
    print e 
    print "Error while trying to save and/or activate!!!"
    dumpStack()
    raise 
    
