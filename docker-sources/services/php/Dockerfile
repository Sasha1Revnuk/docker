FROM php:8.3-fpm

# Arguments defined in docker-compose.yml
#ARG user
#ARG uid

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libonig-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev \
    libfreetype6 \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    sudo \
    libicu-dev \
    libmagickwand-dev --no-install-recommends \
     && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
     && apt-get install -y nodejs \
     && apt-get clean && rm -rf /var/lib/apt/lists/*


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN pecl install imagick-beta

# Install extensions
RUN docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl gd intl
RUN docker-php-ext-configure intl
RUN docker-php-ext-configure gd --enable-gd --with-freetype=/usr/include/ --with-webp=/usr/include/  --with-jpeg=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd
#RUN docker-php-ext-enable imagick
# Install composer

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#RUN useradd -G www-data,root -u $uid -d /home/$user $user
#RUN mkdir -p /home/$user/.composer && \
#    chown -R $user:$user /home/$user
USER root
# Copy existing application directory contents
COPY . /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
