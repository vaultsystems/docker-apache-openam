Apache with OpenAM agent
------------------------

Open https://backstage.forgerock.com/#!/downloads/OpenAM/Web%20Policy%20Agents/3.3.4/Apache%202.4%20Linux%20%2864-bit%29/?platformName=Apache&platformVersion=2.4&platformOs=Linux&platformArchitecture=64-bit#list and download "Apache-v2.4-Linux-64-Agent-3.3.4.zip" from the ForgeRock website (may require registration) and unpack it in this directory.

Start the openam docker container and log on to the OpenAM web interface. In Access Control -> Top Level Realm add a new web agent and call it apache2. Enter OpenAM and application URLs. Enable "SSO Only Mode" and disable "FQDN Check". Now start the Apache2 OpenAM container:

    docker build -t apache-openam .
    docker run -d -e AM_SERVER_URL=https://sso.mysite.com:8443/openam -e AGENT_PASSWORD="XXXXXXXXXXX" -e AGENT_URL=https://service.mysite.com:443 -v $PWD/server.crt:/usr/local/apache2/conf/server.crt -v $PWD/server.key:/usr/local/apache2/conf/server.key -v $PWD/vhosts.conf:/usr/local/apache2/conf/vhosts.conf -v /dev/urandom:/dev/random --name apache -p 443:443 apache-openam

Log out of OpenAM and browse to your application at https://service.mysite.com:443 . You should get redirected to the OpenAM login page. Check the logs inside the container for any errors:

  - /opt/apache24_agent/Agent_001/logs/debug/amAgent
  - /usr/local/apache2/logs/
