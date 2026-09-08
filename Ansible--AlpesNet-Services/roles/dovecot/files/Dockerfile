FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    dovecot-core \
    dovecot-imapd \
    dovecot-ldap \
    gettext-base \
    ldap-utils

RUN groupadd -g 5000 vmail && \
    useradd -u 5000 -g vmail \
    -d /var/mail/vhosts \
    -s /usr/sbin/nologin vmail && \
    mkdir -p /var/mail/vhosts && \
    chown -R vmail:vmail /var/mail/vhosts 
    
RUN mkdir -p /var/spool/postfix/private 

#RUN groupadd -g 102 postfix && \
#    useradd -u 100 -g 102 -M -s /usr/sbin/nologin postfix

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
