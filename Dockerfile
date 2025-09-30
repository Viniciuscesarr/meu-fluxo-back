FROM php:8.2-fpm

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    libonig-dev libzip-dev libpq-dev unzip git curl

# Instala extensões PHP necessárias
RUN docker-php-ext-install pdo pdo_pgsql mbstring zip

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copia todo o projeto
COPY . .

# Instala dependências do Laravel
RUN composer install --no-dev --optimize-autoloader --no-interaction --ignore-platform-reqs

# Ajusta permissões de storage e bootstrap/cache
RUN chmod -R 775 storage bootstrap/cache

# Expõe porta padrão (Railway vai redirecionar para $PORT)
EXPOSE 9000

# Start command padrão
CMD ["php-fpm", "-F"]
