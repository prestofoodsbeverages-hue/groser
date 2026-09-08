FROM php:8.3-cli-alpine

RUN apk add --no-cache \
        git \
        unzip \
        oniguruma-dev \
    && docker-php-ext-install -j$(nproc) mbstring pcntl sockets \
    && rm -rf /tmp/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . /app

RUN composer install \
    --no-dev \
    --prefer-dist \
    --no-interaction \
    --no-progress \
    --optimize-autoloader \
    && chmod -R ug+rwX storage bootstrap/cache

ENV APP_ENV=production
ENV APP_DEBUG=false

EXPOSE 8080

CMD ["sh", "-lc", "php artisan reverb:start --host=0.0.0.0 --port=${PORT:-8080}"]
