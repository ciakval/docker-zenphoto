FROM debian:bookworm

LABEL maintainer="Jan Remes <jan@remes.cz>" \
      version="1.0.0" \
      description="Zenphoto Docker container"

ARG DEBIAN_FRONTEND=noninteractive

EXPOSE 80
VOLUME ["/var/www/html"]

RUN apt-get update

RUN apt-get -y install \
    apache2 \
    php \
    php-mysql \
    libapache2-mod-php \
    curl \
    less \
    locales \
    php-bz2 \
    php-curl \
    php-gd \
    php-imagick \
    php-intl \
    php-mbstring \
    php-tidy \
    php-xml \
    php-zip \
    vim \
    unzip \
    && apt-get clean

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && dpkg-reconfigure locales

ENV ZENPHOTO_VERSION=1.6.5
RUN curl -L https://github.com/zenphoto/zenphoto/archive/v${ZENPHOTO_VERSION}.zip -o /zenphoto.zip

COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]


# Using 'apache2ctl' would be easier (no need to export variables) but it does not correctly
# forward SIGINT to 'apache2', so stopping the container is slo-o-o-w
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_PID_FILE=/var/run/apache2/apache2.pid
ENV APACHE_LOCK_DIR=/var/lock/apache2
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2
CMD [ "apache2", "-D", "FOREGROUND" ]

