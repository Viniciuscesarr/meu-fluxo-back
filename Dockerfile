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

# Instala dependências (INCLUINDO o pacote CORS)
RUN composer install --no-dev --no-scripts --optimize-autoloader --no-interaction --ignore-platform-reqs

# Copia o restante do projeto
COPY . .

# Garante que o pacote CORS está instalado
RUN composer require fruitcake/laravel-cors

# Publica a configuração do CORS
RUN php artisan vendor:publish --tag="cors"

# Limpa e recria o cache
RUN php artisan config:clear && php artisan cache:clear && php artisan config:cache

EXPOSE 8000

# Start command
CMD sh -c "php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000"