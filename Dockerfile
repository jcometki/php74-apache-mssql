FROM php:7.4-apache

LABEL version="1.0"
LABEL description="Imagem base para aplicações PHP 7.4 + Apache + MSSSL Drivers"
LABEL org.opencontainers.image.authors="joseandro@hotmail.com"

ENV TZ=America/Campo_Grande
ENV ACCEPT_EULA=Y

RUN echo 'date.timezone = America/Campo_Grande' > /usr/local/etc/php/conf.d/tzone.ini && \
    echo 'error_reporting = E_ALL & ~E_DEPRECATED & ~E_NOTICE & ~E_WARNING' > /usr/local/etc/php/conf.d/php-errors.ini && \
    sed -i 's/%h/%h %{X-Forwarded-For}i/g' /etc/apache2/apache2.conf

RUN apt-get update && \
    apt-get install -y zip unzip curl nano gnupg2 apt-transport-https libpng-dev zlib1g-dev libmagickwand-dev libonig-dev libzip-dev && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && \
    apt-get install -y msodbcsql17 odbcinst=2.3.7 odbcinst1debian2=2.3.7 unixodbc-dev=2.3.7 unixodbc=2.3.7 && \
    rm -rf /var/lib/apt/lists/*

RUN pecl install sqlsrv-5.10.1 pdo_sqlsrv-5.10.1 imagick
RUN docker-php-ext-enable pdo_sqlsrv sqlsrv imagick
RUN docker-php-ext-configure gd
RUN docker-php-ext-install pdo_mysql mysqli gd mbstring zip calendar exif gettext

WORKDIR /var/www/html
RUN chown www-data:www-data /var/www/html
USER www-data

EXPOSE 80
