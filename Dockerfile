FROM registry.access.redhat.com/ubi8/ubi:latest

# This system is not receiving updates. You can use subscription-manager on the host to register and assign subscriptions.
RUN yum update --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos -y && rm -rf /var/cache/yum
RUN ARCH=$( /bin/arch ) 
RUN subscription-manager repos --enable "codeready-builder-for-rhel-8-${ARCH}-rpms"

RUN yum install epel-release wget curl nc hostname -y && \
yum install https://bintray.com/kong/kong-rpm/download_file?file_path=rhel/8/kong-enterprise-edition-2.3.2.0.rhel8.noarch.rpm -y && \
yum clean all && rm -rf /var/cache/yum

COPY run /usr/bin/run

RUN mkdir -p /etc/kong-init && adduser -u 1001 kong && usermod -aG 0 kong && \
chown -R 1001 /usr/local/kong /usr/bin/run /home/kong /etc/kong /usr/local/lib/luarocks /usr/local/share/lua /etc/kong-init && \
chgrp -R 0 /usr/local/kong /home/kong /usr/bin/run /etc/kong /usr/local/lib/luarocks /usr/local/share/lua /etc/kong-init && \
chmod -R g=u /usr/local/kong /home/kong /etc/kong /usr/bin/run /usr/local/lib/luarocks /usr/local/share/lua /etc/kong-init

USER 1001

EXPOSE 8443 8001 8444 8000

VOLUME ["/etc/kong"] ["/etc/kong-init"]

CMD ["/usr/bin/run"]
