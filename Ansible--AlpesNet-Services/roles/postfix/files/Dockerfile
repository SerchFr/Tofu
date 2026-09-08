FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "postfix postfix/mailname string AlpesNet.local" | debconf-set-selections \
   && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
   && apt-get update \
   && apt-get install -y \
   netcat-openbsd \
   postfix \
   postfix-ldap \
   ldap-utils

RUN groupadd -g 5000 vmail \
   && useradd -u 5000 -g vmail \
   -d /var/mail/vhosts \
   -s /usr/sbin/nologin vmail \
   && mkdir -p /var/mail/vhosts \
   && chown -R vmail:vmail /var/mail/vhosts

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
