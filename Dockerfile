FROM php:7.3.12-cli-alpine

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_DISABLE_XDEBUG_WARN=1

RUN set -xe \
 && apk add --no-cache --virtual .build-deps \            
            tzdata \
	    $PHPIZE_DEPS \
 && apk add --no-cache \
         openssl-dev \
         bash \
         freetype-dev \
         libpng-dev \
         libjpeg-turbo-dev \
         sqlite-dev \
         curl \
         curl-dev \
         libsodium-dev \
         icu-dev \
         libxml2-dev \
         recode-dev \
         libxslt-dev \
         git \
         subversion \
         openssh-client \
         libmcrypt-dev \
         libmcrypt \
         libzip-dev \
         libgcrypt-dev \
         oniguruma-dev \
  && apk --update --no-cache add grep \
  && docker-php-ext-install -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1)\
    	  gd \
        bcmath \
        opcache \
        iconv \
        mysqli \
        pdo \
        pdo_mysql \
        pdo_sqlite \
        zip \
        xml \
        xsl \
        intl \
        json \
        mbstring \
        curl \
        simplexml \
        soap \
        bcmath \
  && docker-php-ext-install sodium \
  && apk del .build-deps \
  && rm -rf /tmp/* /var/cache/apk/* 
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require hirak/prestissimo --no-plugins --no-scripts
