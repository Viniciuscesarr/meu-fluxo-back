FROM php:8.2-fpm

# Instala dependências
RUN apt-get update && apt-get install -y \
    libonig-dev libzip-dev libpq-dev unzip git curl

# Instala extensões PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copia TODO o projeto de uma vez
COPY . .

# Instala dependências (ignora scripts problemáticos)
RUN composer install --no-dev --no-scripts --optimize-autoloader --no-interaction --ignore-platform-reqs

# Configura permissões básicas
RUN chmod -R 775 storage bootstrap/cache

# NÃO executa comandos Artisan durante o build
# Eles serão executados apenas no runtime

EXPOSE 8000

# Comando de inicialização - TUDO no runtime
CMD ["sh", "-c", "php artisan config:clear && php artisan cache:clear && php artisan config:cache && php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000"]