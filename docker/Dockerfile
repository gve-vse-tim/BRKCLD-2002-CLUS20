FROM  ubuntu:18.04
LABEL maintainer "Tim Miller <timmil@cisco.com>"

WORKDIR /var/www

# Install packages
RUN apt-get update -y \
    && apt-get install -y git iproute2 python3-pip virtualenv \
    && apt-get install -y apache2 libapache2-mod-wsgi-py3 python-dev \
    && apt-get install -y default-libmysqlclient-dev mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Install required Python modules
COPY requirements.txt requirements.txt
COPY docker/create_python_venv.sh scripts/
RUN bash ${PWD}/scripts/create_python_venv.sh

# Create Django security key
COPY docker/init_django.py scripts/
RUN /var/www/venv/bin/python3 scripts/init_django.py

# Copy the latest httpd.conf file
COPY docker/clus20_django.conf /etc/apache2/sites-available/100-clus20_django.conf
RUN a2ensite 100-clus20_django && a2dissite 000-default

# Copy database connection information
COPY docker/mysql-connection.json connection.json

# Copy the initialization script
COPY docker/init_database.py scripts/

# Copy in latest git repo
COPY clus20_django/ clus20_django/

EXPOSE 80
USER root

CMD [ "/usr/sbin/apache2ctl", "-DFOREGROUND" ]
