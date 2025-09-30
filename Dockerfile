# --- Base ---
FROM php:8.2-fpm

# --- Instala dependências do sistema ---
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    libpq-dev \
    unzip \
    git \
    curl \
    bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --- Instala extensões PHP necessárias ---
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip

# --- Instala Composer ---
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# --- Define diretório de trabalho ---
WORKDIR /var/www/html

# --- Copia todo o projeto ---
COPY . .

# --- Instala dependências PHP do Laravel ---
RUN composer install --no-dev --optimize-autoloader --no-interaction

# --- Configura permissões de storage e bootstrap/cache ---
RUN chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# --- Porta padrão ---
EXPOSE 8000

# --- Comando de inicialização inline ---
CMD php artisan config:clear && \
    php artisan route:clear && \
    php artisan cache:clear && \
    php artisan view:clear && \
    php artisan config:cache && \
    php artisan migrate --force && \
    php artisan serve --host=0.0.0.0 --port=8000
