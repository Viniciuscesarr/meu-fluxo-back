FROM php:8.2-fpm

# Instala dependências
RUN apt-get update && apt-get install -y \
    libonig-dev libzip-dev libpq-dev unzip git curl

# Instala extensões PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql pgsql mbstring zip

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copia primeiro os arquivos do composer
COPY composer.json composer.lock ./

# Instala dependências SEM tentar instalar pacotes desnecessários
RUN composer install --no-dev --no-scripts --optimize-autoloader --no-interaction --ignore-platform-reqs

# Copia o restante do projeto
COPY . .

# Cria/atualiza o arquivo CORS para Laravel 12
RUN mkdir -p config && cat > config/cors.php << 'EOF'
<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie', 'login', 'logout', 'register', 'user'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['https://meu-fluxo-nine.vercel.app'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,
];
EOF

# Configura permissões
RUN chmod -R 775 storage bootstrap/cache

# Gera key da aplicação se não existir
RUN if [ ! -f .env ]; then \
        cp .env.example .env && \
        php artisan key:generate; \
    fi

# Limpa e recria o cache
RUN php artisan config:clear && php artisan cache:clear && php artisan config:cache

EXPOSE 8000

# Start command
CMD sh -c "php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000"