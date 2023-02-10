# Utilisez une image Debian Lite comme base
FROM debian:bullseye-slim

# Mettre à jour les packages et installer Apache, PHP et les paquets nécessaires
RUN apt-get update && \
    apt-get install -y apache2 php php-mysql curl libapache2-mod-php && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configurer Apache pour utiliser PHP
RUN a2enmod rewrite && \
    a2enmod proxy && \
    a2enmod proxy_fcgi && \
    a2enmod ssl

# Télécharger et installer ApacheGUI
RUN curl -L https://downloads.sourceforge.net/project/apachemobilefilter/ApacheGUI/ApacheGUI-2.5.0/ApacheGUI-2.5.0.tar.gz | tar xz -C /var/www/html/

# Ajouter les fichiers de configuration pour ApacheGUI
COPY apachegui.conf /etc/apache2/sites-available/

# Activer la configuration pour ApacheGUI
RUN a2ensite apachegui && \
    a2dissite 000-default

# Exposer le port 80 pour ApacheGUI
EXPOSE 80

# Définir le point d'entrée pour le conteneur
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]