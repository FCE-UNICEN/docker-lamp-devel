#!/bin/bash
which pear > /dev/null 2>&1
# si no existe intalamos via apt-get
if [ $? -ne 0 ]; then
	echo "Pear is required, installing pear"
	apt-get update && apt-get -y install php-pear 
	pear channel-update pear.php.net > /dev/null
fi
pear -q install -f PEAR-1.10.1
pear -q install -f Archive_Tar 
pear -q install -f Auth Auth_SASL 
pear -q install -f Console_Getopt DB File HTML_Common HTML_QuickForm 
pear -q install -f HTTP HTTP_Client HTTP_Request 
pear -q install -f Log 
pear -q install -f MDB2 MDB2_Driver_mysql MDB2_Driver_mysqli 
pear -q install -f Mail Mail_Mime Mail_Queue Mail_mimeDecode 
pear -q install -f Net_SMTP Net_Socket Net_URL Net_UserAgent_Detect 
pear -q install -f Structures_Graph 
pear -q install -f XML_Parser XML_RPC XML_Util
