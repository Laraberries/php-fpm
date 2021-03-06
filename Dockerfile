#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

ARG MINOR_PHP_VERSION=8.0
ARG FULL_PHP_VERSION=8.0-fpm

FROM php:${FULL_PHP_VERSION}

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

ARG MINOR_PHP_VERSION=8.0
ARG FULL_PHP_VERSION=8.0-fpm

#
#--------------------------------------------------------------------------
# Software's Installation
#--------------------------------------------------------------------------
#
# Installing tools and PHP extentions using "apt", "docker-php", "pecl",
#

# Install "curl", "libmemcached-dev", "libpq-dev", "libjpeg-dev",
#         "libpng-dev", "libfreetype6-dev", "libssl-dev", "libmcrypt-dev",
RUN set -eux; \
    apt-get update -y; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
            curl \
            libmemcached-dev \
            libz-dev \
            libpq-dev \
            libjpeg-dev \
            libpng-dev \
            libfreetype6-dev \
            libssl-dev \
            libmcrypt-dev;

RUN if [ $MINOR_PHP_VERSION = "7.4" ] || [ $MINOR_PHP_VERSION = "8.0" ] || [ $FULL_PHP_VERSION = "latest" ]; then \
        apt-get install -y --no-install-recommends libonig-dev \
    ;fi

RUN rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    # Install the PHP pdo_mysql extention
    docker-php-ext-install pdo_mysql; \
    # Install the PHP pdo_pgsql extention
    docker-php-ext-install pdo_pgsql && \
    # Install the PHP gd library
    if [ $MINOR_PHP_VERSION = "7.4" ] || [ $MINOR_PHP_VERSION = "8.0" ] || [ $FULL_PHP_VERSION = "latest" ]; then \
        docker-php-ext-configure gd \
            --prefix=/usr \
            --with-jpeg \
            --with-freetype; \
    else \
        docker-php-ext-configure gd \
            --with-jpeg-dir=/usr/lib \
            --with-freetype-dir=/usr/include/freetype2; \
    fi && \
    docker-php-ext-install gd;
