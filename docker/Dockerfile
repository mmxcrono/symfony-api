FROM php:8.2.10-fpm-alpine

ARG APP_ENV=dev
ARG USER=nginx
ARG INSTALL_XDEBUG=N

RUN echo "UTC" > /etc/timezone


RUN apk add --update \
    --no-cache \
    $PHPIZE_DEPS \
    curl \
    git \
    linux-headers \
    openssh \
    unzip \
    nginx \
    libcap \
    bash \
    vim vim-doc vim-tutor \
    composer

RUN wget 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' && bash setup.alpine.sh

RUN apk add --update symfony-cli

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

RUN if [[ "$APP_ENV" == "dev" ]]; then \
    mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
else \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
fi

WORKDIR /var/www/html
COPY ./src .

RUN if [[ "$APP_ENV" == "dev" ]]; then \
    composer install \
        --ignore-platform-reqs \
        --no-interaction \
        --no-plugins \
        --no-scripts \
        --no-suggest \
        --no-progress \
        --prefer-dist; \
else \
    sed -i \
        -e "s/APP_ENV=.*/APP_ENV=production/" \
        ./.env; \
    composer install \
        --ignore-platform-reqs \
        --no-interaction \
        --no-plugins \
        --no-scripts \
        --no-suggest \
        --no-progress \
        --prefer-dist \
        --optimize-autoloader; \
fi

COPY ./docker/nginx/default.conf /etc/nginx/http.d/

COPY ./docker/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

# Allow nginx to bind to privileged ports
RUN setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx

# Set up user to run as, permissions
RUN addgroup $USER www-data && addgroup $USER nginx
RUN addgroup www-data $USER && addgroup nginx $USER
RUN addgroup www-data nginx && addgroup nginx www-data

RUN mkdir -p /home/$USER/.composer

RUN chown -R $USER:$USER /home/$USER
RUN chown -R $USER:$USER /var/www

RUN chmod 777 -R /var/www/html/var

RUN if [[ "${INSTALL_XDEBUG}" == "Y" ]]; then \
    install-php-extensions xdebug \
    && echo 'xdebug.mode=coverage,debug,develop' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.idekey=docker' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.log_level=7' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.start_with_request=yes' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.client_host=host.docker.internal' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.discover_client_host=1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo 'xdebug.client_port=9005' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
fi

USER $USER

CMD symfony server:start --no-tls --port=80 --dir=public