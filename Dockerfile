FROM httpd:2.4
MAINTAINER Christoph Dwertmann <christoph.dwertmann@vaultsystems.com.au>
RUN apt-get update && \
  apt-get install -y default-jre && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
ADD web_agents /opt
ADD agent.conf /opt
RUN sed -i '/LoadModule proxy/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/Include conf\/extra\/httpd-ssl.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule ssl_module modules\/mod_ssl.so/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule slotmem_shm_module modules\/mod_slotmem_shm.so/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule lbmethod_byrequests_module modules\/mod_lbmethod_byrequests.so/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule rewrite_module modules\/mod_rewrite.so/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/Include conf\/extra\/httpd-ssl.conf/d' /usr/local/apache2/conf/httpd.conf && \
    echo "IncludeOptional conf/vhosts.conf" >> /usr/local/apache2/conf/httpd.conf

CMD echo $AGENT_PASSWORD > /opt/pwd && \
    sed -i "s@http:\/\/sso.example.com\:8080\/openam@$AM_SERVER_URL@" /opt/agent.conf && \
    sed -i "s@https:\/\/www.example.com\:443@$AGENT_URL@" /opt/agent.conf && \
    /opt/apache24_agent/bin/agentadmin --install --acceptLicense --useResponse /opt/agent.conf && \
    sed -i.bak s/iPlanetDirectoryPro$/iPlanetDirectoryProNew/g /opt/apache24_agent/Agent_001/config/OpenSSOAgentConfiguration.properties && \
    rm /opt/pwd && \
    httpd-foreground
