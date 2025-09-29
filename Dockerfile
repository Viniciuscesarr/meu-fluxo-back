FROM php:8.2-fpm

# Instala dependências
RUN apt-get update && apt-get install -y \
    libonig-dev libzip-dev libpq-dev unzip git curl

# Instala extensões PHP
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copia primeiro os arquivos do composer
COPY composer.json composer.lock ./

# Instala dependências
RUN composer install --no-dev --no-scripts --optimize-autoloader --no-interaction --ignore-platform-reqs

# Copia o restante do projeto (incluindo config/cors.php se existir)
COPY . .

# Se o arquivo cors.php não existir, cria um padrão
RUN if [ ! -f config/cors.php ]; then \
    mkdir -p config && \
    echo '<?php' > config/cors.php && \
    echo '' >> config/cors.php && \
    echo 'return [' >> config/cors.php && \
    echo "    'paths' => ['api/*', 'sanctum/csrf-cookie', 'login', 'logout', 'register', 'user']," >> config/cors.php && \
    echo "    'allowed_methods' => ['*']," >> config/cors.php && \
    echo "    'allowed_origins' => ['https://meu-fluxo-nine.vercel.app']," >> config/cors.php && \
    echo "    'allowed_origins_patterns' => []," >> config/cors.php && \
    echo "    'allowed_headers' => ['*']," >> config/cors.php && \
    echo "    'exposed_headers' => []," >> config/cors.php && \
    echo "    'max_age' => 0," >> config/cors.php && \
    echo "    'supports_credentials' => true," >> config/cors.php && \
    echo '];' >> config/cors.php; \
fi

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