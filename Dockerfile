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

# --- Copia entrypoint script ---
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# --- Porta padrão ---
EXPOSE 8000

# --- Comando de inicialização ---
CMD ["entrypoint.sh"]
