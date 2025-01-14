# Utiliser l'image officielle PHP avec PHP-FPM
FROM php:8.1-fpm

# Définir le répertoire de travail
WORKDIR /var/www/html

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql mbstring xml zip bcmath opcache intl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*   # Nettoyage pour réduire la taille de l'image

# Installer Composer (via l'image officielle Composer)
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Créer les répertoires nécessaires pour Laravel
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache

# Définir les permissions nécessaires pour Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copier le code de l'application
COPY . .

# Exposer le port 9000 pour PHP-FPM
EXPOSE 9000

# Exécuter PHP-FPM
CMD ["php-fpm"]
