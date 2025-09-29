FROM php:8.2-fpm

# Instala dependências
RUN apt-get update && apt-get install -y \
    libonig-dev libzip-dev libpq-dev unzip git curl

# Instala extensões PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql pgsql mbstring zip

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copia primeiro apenas os arquivos necessários para composer
COPY composer.json composer.lock ./

# Instala dependências SEM o pacote CORS descontinuado
RUN composer install --no-dev --no-scripts --optimize-autoloader --no-interaction --ignore-platform-reqs

# Copia o restante do projeto
COPY . .

# Cria o arquivo CORS manualmente (solução nativa do Laravel)
RUN mkdir -p config && \
    echo '<?php' > config/cors.php && \
    echo '' >> config/cors.php && \
    echo 'return [' >> config/cors.php && \
    echo "    'paths' => ['api/*', 'sanctum/csrf-cookie', 'login', 'logout', 'register']," >> config/cors.php && \
    echo "    'allowed_methods' => ['*']," >> config/cors.php && \
    echo "    'allowed_origins' => ['https://meu-fluxo-nine.vercel.app']," >> config/cors.php && \
    echo "    'allowed_origins_patterns' => []," >> config/cors.php && \
    echo "    'allowed_headers' => ['*']," >> config/cors.php && \
    echo "    'exposed_headers' => []," >> config/cors.php && \
    echo "    'max_age' => 0," >> config/cors.php && \
    echo "    'supports_credentials' => true," >> config/cors.php && \
    echo '];' >> config/cors.php

# Garante que as permissões estão corretas
RUN chown -R www-data:www-data /var/www/html/storage
RUN chown -R www-data:www-data /var/www/html/bootstrap/cache

# Limpa e recria o cache
RUN php artisan config:clear && php artisan cache:clear && php artisan config:cache

EXPOSE 8000

# Start command
CMD sh -c "php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000"