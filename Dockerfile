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

# 6. Copia APENAS os arquivos do Composer primeiro
COPY composer.json composer.lock ./

# 7. Instala dependências SEM otimização primeiro
RUN composer install --no-dev --no-scripts --no-interaction

# 8. Copia o resto do projeto
COPY . .

# 9. Executa otimização depois
RUN composer dump-autoload --optimize

# 10. Expõe a porta 8000
EXPOSE 8000

# 11. Start command
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
