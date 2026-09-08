FROM roundcube/roundcubemail:latest-apache

RUN a2enmod ssl

COPY roundcube-ssl.conf /etc/apache2/sites-available/roundcube-ssl.conf

RUN a2ensite roundcube-ssl.conf
