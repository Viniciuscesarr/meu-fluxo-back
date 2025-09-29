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

# 6. Copia APENAS os arquivos necessários para o Composer primeiro
COPY composer.json composer.lock ./

# 7. Instala dependências SEM scripts
RUN composer install --no-dev --no-scripts --no-interaction --ignore-platform-reqs

# 8. Copia o resto do projeto
COPY . .

# 9. Cria o arquivo CORS manualmente se não existir
RUN if [ ! -f config/cors.php ]; then \
    echo '<?php return [' \
    '"paths" => ["api/*", "sanctum/csrf-cookie"],' \
    '"allowed_methods" => ["*"],' \
    '"allowed_origins" => ["*"],' \
    '"allowed_origins_patterns" => [],' \
    '"allowed_headers" => ["*"],' \
    '"exposed_headers" => [],' \
    '"max_age" => 0,' \
    '"supports_credentials" => false,' \
    '];' > config/cors.php; \
    fi

# 10. Expõe a porta 8000
EXPOSE 8000

# 11. Start command com migrações
CMD sh -c "php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000"
