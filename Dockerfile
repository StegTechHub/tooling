FROM php:7.2.32-apache-buster
#MAINTAINER Tool Tooling

RUN docker-php-ext-install mysqli
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
COPY start-apache /usr/local/bin
RUN chmod +x /usr/local/bin/start-apache && a2enmod rewrite

# Copy application source
COPY html /var/www
RUN chown -R www-data:www-data /var/www

EXPOSE 80

CMD ["start-apache"]
