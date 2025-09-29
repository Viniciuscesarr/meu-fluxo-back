# 1. Imagem base PHP com FPM
FROM php:8.2-fpm

# 2. Instala dependências do sistema (ADICIONE libpq-dev AQUI)
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    libpq-dev \  # <--- ADICIONE ESTA LINHA
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql pgsql mbstring zip  # <--- ADICIONE pdo_pgsql pgsql

# 3. Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 4. Define diretório de trabalho
WORKDIR /var/www/html

# 5. Copia todo o projeto
COPY . .

# 6. Instala dependências do Laravel
RUN composer install --no-dev --optimize-autoloader

# 7. Expõe a porta 8000 (Laravel Serve)
EXPOSE 8000

# 8. Start command do Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
