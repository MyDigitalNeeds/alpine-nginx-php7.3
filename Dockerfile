FROM nickmaietta/alpine-nginx-php73:latest

RUN apk --no-cache add git composer

COPY src/ /var/www/html/

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

WORKDIR /var/www/
COPY ./composer.json /var/www/
RUN composer install