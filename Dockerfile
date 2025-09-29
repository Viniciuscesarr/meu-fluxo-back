# 1. Imagem base PHP com FPM
FROM php:8.2-fpm

# 2. Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    libpq-dev \
    unzip \
    git \
    curl

# 3. Instala extensões PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql pgsql mbstring zip

# 4. Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Define diretório de trabalho
WORKDIR /var/www/html

# 6. Copia todo o projeto
COPY . .

# 7. Instala dependências do Laravel
RUN composer install --no-dev --optimize-autoloader

# 8. Cache das configurações (IMPORTANTE)
RUN php artisan config:cache

# 9. Expõe a porta 8000
EXPOSE 8000

# 10. Start command
CMD sh -c "php artisan config:cache && php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000"
