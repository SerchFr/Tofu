#!/bin/bash
set -e
envsubst < /etc/dovecot/dovecot-ldap.conf.ext.template > /etc/dovecot/dovecot-ldap.conf.ext
exec dovecot -F
