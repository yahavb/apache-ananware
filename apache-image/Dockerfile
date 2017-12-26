FROM alpine:3.4


RUN apk --update add bash apache2-ssl php5 php5-apache2 php5-curl php5-mysqli php5-openssl php5-json mysql-client curl vim

RUN cd /var/www/ \
  && mkdir -p /run/apache2 \
  && chgrp www-data /run/apache2 \
  && chmod 775 /run/apache2 \
  && chown apache:apache logs \
  && chmod g+w /var/log/apache2 \
  && addgroup apache wheel

ADD httpd.conf /etc/apache2/httpd.conf
ADD ssl.conf /etc/apache2/conf.d/ssl.conf
#RUN sed -i 's#ErrorLog /proc/self/fd/2#ErrorLog "|$/bin/cat 1>\&2"#' /etc/apache2/httpd.conf
#RUN sed -i 's#CustomLog /proc/self/fd/1 combined#CustomLog "|/bin/cat" combined#' /etc/apache2/httpd.conf
