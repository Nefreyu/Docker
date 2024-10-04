# Usa una imagen base oficial de PHP con Apache
FROM php:8.3-apache

# Instala dependencias y extensiones necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libicu-dev \
    libpq-dev \
    libzip-dev \
    zlib1g-dev \
    libonig-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    curl \
    zip \
    nano \
    redis-server \
    memcached \
    openssl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install intl pdo pdo_mysql zip gd opcache bcmath mbstring

# Habilitar mod_rewrite para Symfony en Apache
RUN a2enmod rewrite ssl

# Configuración de Apache para usar SSL
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar los archivos del proyecto
COPY . /var/www/html

# Permisos de Apache
RUN chown -R www-data:www-data /var/www/html

# Exponer puertos para HTTP y HTTPS
EXPOSE 80 443
