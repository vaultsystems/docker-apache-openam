Apache with OpenAM agent
------------------------

Download Apache-v2.4-Linux-64-Agent-3.3.4.zip from the ForgeRock website (may require registration) and unpack in this directory.

    docker build -t apache-openam .
    docker run -d -e AM_SERVER_URL=http://sso.mysite.com:8080/openam -e AGENT_PASSWORD="XXXXXXXXXXX" -e AGENT_URL=https://service.mysite.com:443 -v $PWD/server.crt:/usr/local/apache2/conf/server.crt -v $PWD/server.key:/usr/local/apache2/conf/server.key -v $PWD/vhosts.conf:/usr/local/apache2/conf/vhosts.conf -v /dev/urandom:/dev/random --name apache -p 443:443 apache-openam
