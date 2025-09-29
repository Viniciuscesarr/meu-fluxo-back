FROM php:8.2-fpm

# Instala dependências
RUN apt-get update && apt-get install -y \
    libonig-dev libzip-dev libpq-dev unzip git curl

# Instala extensões PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql pgsql mbstring zip

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copia todo o projeto
COPY . .

# Instala dependências SEM scripts
RUN composer install --no-dev --no-scripts --optimize-autoloader --no-interaction --ignore-platform-reqs

# Cria o arquivo CORS usando echo
RUN mkdir -p config && \
    echo '<?php' > config/cors.php && \
    echo '' >> config/cors.php && \
    echo 'return [' >> config/cors.php && \
    echo "    'paths' => ['api/*', 'sanctum/csrf-cookie']," >> config/cors.php && \
    echo "    'allowed_methods' => ['*']," >> config/cors.php && \
    echo "    'allowed_origins' => ['*']," >> config/cors.php && \
    echo "    'allowed_origins_patterns' => []," >> config/cors.php && \
    echo "    'allowed_headers' => ['*']," >> config/cors.php && \
    echo "    'exposed_headers' => []," >> config/cors.php && \
    echo "    'max_age' => 0," >> config/cors.php && \
    echo "    'supports_credentials' => false," >> config/cors.php && \
    echo '];' >> config/cors.php

# Limpa cache problemático
RUN php artisan config:clear

EXPOSE 8000

# Start command
CMD sh -c "php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000"
