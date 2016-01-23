Apache 2.4 with OpenAM agent
----------------------------

Download ["Apache-v2.4-Linux-64-Agent-3.3.4.zip"](https://backstage.forgerock.com/#!/downloads/OpenAM/Web%20Policy%20Agents/3.3.4/Apache%202.4%20Linux%20%2864-bit%29/?platformName=Apache&platformVersion=2.4&platformOs=Linux&platformArchitecture=64-bit#list) from the ForgeRock website (requires registration) and unpack it in this directory.

Start the [OpenAM docker container](https://github.com/vaultsystems/docker-openam) and configure it via the web interface. Then go to *Access Control -> Top Level Realm* and add a new web agent named *apache2*. Enter the OpenAM and application URLs. Enable *SSO Only Mode* and disable *FQDN Check*. 

Run your application in a docker container, but do not expose its ports. Create a vhosts.conf from the example and configure the name and port of your application in the *ProxyPass* and *ProxyPassReverse* lines. The idea is to use docker links to allow the apache container to access the application container, so that the application can only be accessed after successful OpenAM authentication through apache.

Now build and run the Apache/OpenAM container:

    docker build -t apache-openam .
    docker run -d -e AM_SERVER_URL=https://sso.mysite.com:8443/openam -e AGENT_PASSWORD="XXXXXXXXXXX" -e AGENT_URL=https://service.mysite.com:443 -v $PWD/server.crt:/usr/local/apache2/conf/server.crt -v $PWD/server.key:/usr/local/apache2/conf/server.key -v $PWD/vhosts.conf:/usr/local/apache2/conf/vhosts.conf -v /dev/urandom:/dev/random --name apache -p 443:443 --link app:app apache-openam

Log out of OpenAM and browse to your application at https://service.mysite.com . You should get redirected to the OpenAM login page. Check the logs inside the container for any errors:

  - /opt/apache24_agent/Agent_001/logs/debug/amAgent
  - /usr/local/apache2/logs/
